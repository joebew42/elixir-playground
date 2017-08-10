defmodule HelloWorldTest do
  use ExUnit.Case
  doctest HelloWorld

  test "hello should returns world" do
    assert HelloWorld.hello() == :world
  end
end
