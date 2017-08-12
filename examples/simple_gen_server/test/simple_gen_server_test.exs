defmodule SimpleGenServerTest do
  use ExUnit.Case
  doctest SimpleGenServer

  setup do
    {:ok, pid} = start_supervised SimpleGenServer
    %{server: pid}
  end

  test "returns :ok when a new name is registered", %{server: pid} do
    assert :ok == SimpleGenServer.create(pid, "a_new_name")
  end

  test "returns :already_registered when a name is already registered", %{server: pid} do
    SimpleGenServer.create(pid, "same_name")

    assert :already_registered == SimpleGenServer.create(pid, "same_name")
  end
end
