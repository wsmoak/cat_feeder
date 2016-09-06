defmodule CatFeeder.ProximityWorker do
  require Logger
  use GenServer

# 10:00 AM to 7:59 PM
@ active_hours 10..19

# wait in minutes * seconds * milliseconds
  @wait           1200000

# register        address
  @cmd            0x80
  @prox_result_h  0x87
  @prox_result_l  0x88
  @int_ctrl       0x89
  @low_thresh_h   0x8A  # register #10
  @low_thresh_l   0x8B
  @high_thresh_h  0x8C
  @high_thresh_l  0x8D
  @int_status     0x8E  # register #14

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: ProximityChecker)
  end

  # Server Callbacks

  def init(_opts) do

    pid = Process.whereis( ProximitySensor )

    # set bits 0 and 1 to turn on periodic proximity measurements
    I2c.write(pid, <<@cmd, 0x03>> )

    # set the low threshold
    I2c.write(pid, <<@low_thresh_h, 0x00>> )
    I2c.write(pid, <<@low_thresh_l, 0x00>> )

    # set the high threshold, 2100 is 0x834
    I2c.write(pid, <<@high_thresh_h, 0x08 >> )
    I2c.write(pid, <<@high_thresh_l, 0x34 >> )

    # configure the chip to interrupt when threshold is exceeded
    I2c.write(pid, <<@int_ctrl, 0x02 >>)  # 0000 0010

    # tell elixir_ale we're looking for the pin to be pulled low
    int_pid = Process.whereis( InterruptPin )
    Gpio.set_int(int_pid, :falling)

    # set the initial state
    {:ok, %{:status => :idle}}
  end

  def terminate(reason, _state) do
    Logger.debug "Received call to terminate for #{reason}"
    pid = Process.whereis(ProximitySensor)
    # turn off proximity sensing
    I2c.write(pid, <<@cmd, 0x00>> )
  end

  # the official timer ended, so change the state
  def handle_info(:time_is_up, state) do
    Logger.debug "Time is up! Ready to feed again"
    {:noreply, Map.update!(state, :status, fn _x -> :idle end) }
  end

  def handle_info({:gpio_interrupt, _pin, :falling}, state = %{status: :waiting}) do
    Logger.debug "Interrupted, but still waiting"
    clear_interrupt_status
    {:noreply, state}
  end

  def handle_info({:gpio_interrupt, _pin, :falling}, state = %{status: :idle} ) do
    hour = Timex.DateTime.now("America/New_York").hour
    if hour in @active_hours do
      Logger.debug "FEED THE CAT!"
      # turn the motor
      pid = Process.whereis( StepperTurner )
      Process.send(pid, :bump, [])
      # wait before feeding again
      Process.send_after(ProximityChecker, :time_is_up, @wait)
      clear_interrupt_status
      {:noreply, Map.update!(state, :status, fn x -> :waiting end) }
    else
      Logger.debug "Outside of allowed hours, not feeding"
      {:noreply, state}
    end
  end

  def handle_info(msg, state) do
    IO.write "in generic handle_info, msg is "
    IO.inspect msg
    IO.write " ... and state is "
    IO.inspect state
    {:noreply, state}
  end

  # Helper Functions

  def check_proximity do
    pid = Process.whereis(ProximitySensor)
    << val :: 16 >> = I2c.write_read(pid, <<@prox_result_h>> ,2)
    Logger.debug "Proximity value #{val}"
    val
  end

  def check_interrupt_status do
    pid = Process.whereis(ProximitySensor)
    << val :: 8 >> = I2c.write_read(pid, <<@int_status>>, 1)
    Logger.debug "Interrupt Status #{inspect(val, base: :hex)}"
  end

  def clear_interrupt_status do
    pid = Process.whereis(ProximitySensor)
    << val :: 8 >> = I2c.write_read(pid, <<@int_status>>, 1)
    # if any of the bits are set, clear them by writing a 1 back to them
    if val > 0 do
      Logger.debug "Clearing interrupt status, was #{inspect(val, base: :hex)}"
      I2c.write(pid, <<@int_status, val >> )
    end
  end
end
