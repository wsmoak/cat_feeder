defmodule CatFeeder.ProximityWorker do
  require Logger
  use GenServer

# register        address
  @cmd            0x80
  @prox_result_h  0x87
  @prox_result_l  0x88

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :prox)
  end

  # Server Callbacks 

  def init(_opts) do

    {:ok,pid} = I2c.start_link("i2c-1", 0x13)
    # turn on proximity sensing by setting bits 0 and 1
    I2c.write(pid, <<@cmd, 0x03>> )

    Task.async( __MODULE__, :check_proximity, [pid] )

    {:ok, %{state: :idle}}

  end

  def handle_call(request, from, state) do
    IO.write "state in handle_call is "
    IO.inspect state

  end

  # Helper Functions

  def check_proximity(pid) do
    << val :: 16 >> = I2c.write_read(pid,<<@prox_result_h>> ,2) 
    Logger.debug "Proximity value #{val}" 
 
    # value determined by running measure/1 and observing the output
    if val > 2100 do
      Logger.debug "Sending message to feed the cat!"  
      #Gpio.write(led_pid,1)
      {:ok, %{state: :waiting}}
    else
      Logger.debug "nobody around..."
      #Gpio.write(led_pid,0)
      {:ok, %{state: :idle}}
    end
  end

end
