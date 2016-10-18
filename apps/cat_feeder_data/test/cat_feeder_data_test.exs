defmodule CatFeederDataTest do
  use ExUnit.Case
  doctest CatFeederData

  test "it stores and retrieves a value" do
    CatFeederData.Worker.set_last_fed_at("abcd")
    assert CatFeederData.Worker.get_last_fed_at == "abcd"
  end
end

