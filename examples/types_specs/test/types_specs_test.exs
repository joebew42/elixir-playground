defmodule TypesSpecsTest do
  use ExUnit.Case
  doctest TypesSpecs

  test "greets the world" do
    assert TypesSpecs.hello() == :world
  end
end
