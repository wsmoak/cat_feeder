defmodule CatFeeder.ServoWorker do
  use GenServer

  # Server (callbacks)

  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  # Client



  # Helper Functions

end
