defmodule CatFeeder.DateTimeWorker do
  use GenServer
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: DateTime)
  end

  def set_time_in_utc(year,month,day,hour,minute) do
    System.cmd("date",[month <> day <> hour <> minute <> year])
  end

  # Server Callbacks

  def init(_opts) do
    Logger.debug("Setting up NTP...")
    # TODO
    {:ok, :nostate}
  end
end
