defmodule CatFeeder.ProximityWorker do
  require Logger
  use GenServer

# Always on while sorting out WiFi with Nerves
@ active_hours 0..23

# wait in minutes * seconds * milliseconds
  @wait           1200000

# register        address
  @cmd            0x80
  @prox_result_h  0x87
  @prox_result_l  0x88

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: ProximityChecker)
  end

  # Server Callbacks

  def init(_opts) do

    # turn on proximity sensing by setting bits 0 and 1
    pid = Process.whereis( ProximitySensor )
    I2c.write(pid, <<@cmd, 0x03>> )

    # start it up! wait a bit so the process exists.
    Process.send_after(ProximityChecker, :check_it, 1000)

    {:ok, %{:status => :idle}}

  end

  def terminate(reason, _state) do
    Logger.debug "Received call to terminate for #{reason}"
    pid = Process.whereis(ProximitySensor)
    # turn off proximity sensing
    I2c.write(pid, <<@cmd, 0x00>> )
  end

  def handle_info(:check_it, state = %{:status => :waiting} ) do
    IO.write "state in :check_it handle_info w/ :waiting pattern match is "
    IO.inspect state
    # we've received a request to check the proximity
    # but we're still waiting ...
    # we have to get the official :time_is_up message before we
    # change state
    Logger.debug "it's not time yet!"
    # TODO: sanity check and reset if we've been waiting too long
    # Store the last trigger time in the state?
    {:noreply, state}
  end

  # the official timer ended, so change the state
  def handle_info(:time_is_up, state) do
    Process.send_after(ProximityChecker, :check_it, 513)
    {:noreply, Map.update!(state, :status, fn _x -> :idle end) }
  end

  # this is a 'custom message' in handle_info
  def handle_info(:check_it, state) do
    IO.write "state in :check_it handle_info w/ pattern match is "
    IO.inspect state

    val = check_proximity
    hour = Timex.DateTime.now("America/New_York").hour

    if val > 2100 and hour in @active_hours do
      Logger.debug "FEED THE CAT!"
      # spin the servo
      pid = Process.whereis( StepperTurner )
      Process.send(pid, :bump, [])
      # wait before feeding again
      Process.send_after(ProximityChecker, :time_is_up, @wait)
      {:noreply, Map.update!(state, :status, fn x -> :waiting end) }
    else
      Process.send_after(ProximityChecker, :check_it, 513)
      {:noreply, Map.update!(state, :status, fn x -> :idle end) }
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
    << val :: 16 >> = I2c.write_read(pid,<<@prox_result_h>> ,2)
    Logger.debug "Proximity value #{val}"
    val
  end

end
