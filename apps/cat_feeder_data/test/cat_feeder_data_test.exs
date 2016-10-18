defmodule CatFeederDataTest do
  use ExUnit.Case
  doctest CatFeederData

  setup do
    pid = Process.whereis( DataWorker )
    {:ok, worker: pid}
  end

  test "it stores and retrieves a value", %{worker: pid} do
    CatFeederData.Worker.set_last_fed_at(pid, "abcd")
    assert CatFeederData.Worker.get_last_fed_at(pid) == "abcd"
  end
end

