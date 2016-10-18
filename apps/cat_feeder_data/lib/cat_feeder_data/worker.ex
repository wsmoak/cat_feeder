defmodule CatFeederData.Worker do
  use GenServer
  require Logger

  @path Application.get_env(:cat_feeder_data, :path)

  # Client API

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: DataWorker)
  end

  def get_last_fed_at do
    pid = Process.whereis( DataWorker )
    GenServer.call(pid, :get_last_fed_at)
  end

  def set_last_fed_at(time) do
    pid = Process.whereis( DataWorker )
    GenServer.cast(pid, {:set_last_fed_at,time})
  end

  # Server Callbacks

  def init(_opts) do
    Logger.debug("Setting up Persistent Storage...")
    :ok = PersistentStorage.setup path: @path
    {:ok, :nostate}
  end

  def handle_call(:get_last_fed_at, _from, state) do
    time = PersistentStorage.get :last_fed_at
    #display_time = Timex.format!(time, "{h12}:{m}")
    {:reply, time, state}
  end

  def handle_cast({:set_last_fed_at, time}, state) do
    PersistentStorage.put last_fed_at: time
    {:noreply, state}
  end
end
