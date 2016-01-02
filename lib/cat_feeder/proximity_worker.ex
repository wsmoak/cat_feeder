defmodule CatFeeder.ProximityWorker do
  use GenServer

  # Client

  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  # Server Callbacks 



  # Helper Functions

end
