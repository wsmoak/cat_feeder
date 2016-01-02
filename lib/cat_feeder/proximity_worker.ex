defmodule CatFeeder.ProximityWorker do
  use GenServer

# register        address
  @cmd            0x80

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :prox)
  end

  # Server Callbacks 

  def init(_opts) do

    {:ok,prox_pid} = I2c.start_link("i2c-1", 0x13)
    # turn on proximity sensing by setting bits 0 and 1
    I2c.write(prox_pid, <<@cmd, 0x03>> )

    {:ok, %{state: :idle}}

  end

  def handle_call(request, from, state) do
    IO.write "state in handle_call is "
    IO.inspect state

  end

  # Helper Functions

end
