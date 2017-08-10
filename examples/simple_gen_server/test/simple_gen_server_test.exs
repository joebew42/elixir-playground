defmodule SimpleGenServerTest do
  use ExUnit.Case
  doctest SimpleGenServer

  test "greets the world" do
    assert SimpleGenServer.hello() == :world
  end
end
