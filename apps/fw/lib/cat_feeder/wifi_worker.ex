defmodule CatFeeder.WifiWorker do

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: WifiStarter)
  end

  # Server Callbacks

  def init(_opts) do
    opts = Application.get_env(:cat_feeder, :wlan0)
    Nerves.InterimWiFi.setup "wlan0", opts
    {:ok, self}
  end
end
