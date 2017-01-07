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

    # Meanwhile, default to 15:00 UTC (10 or 11 am Eastern, which is during the allowed hours, so the machine will work when powered up. The date doesn't matter for now.)
    set_time_in_utc("2017","01","01","15","00")
    {:ok, :nostate}
  end
end
