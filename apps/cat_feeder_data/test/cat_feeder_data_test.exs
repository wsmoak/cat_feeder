defmodule CatFeederDataTest do
  use ExUnit.Case
  use Timex

  doctest CatFeederData

  test "it stores and retrieves a value" do
    time = Timex.now()
    CatFeederData.Worker.set_last_fed_at(time)
    assert CatFeederData.Worker.get_last_fed_at == time
  end
end

