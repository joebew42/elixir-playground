defmodule SimpleGenServerTest do
  use ExUnit.Case
  doctest SimpleGenServer

  setup do
    {:ok, registry} = start_supervised SimpleGenServer
    %{server: registry}
  end

  test "returns :ok when a new name is registered", %{server: registry} do
    assert :ok == SimpleGenServer.create(registry, "a_new_name")
  end

  test "returns :already_registered when a name is already registered", %{server: registry} do
    SimpleGenServer.create(registry, "same_name")

    assert :already_registered == SimpleGenServer.create(registry, "same_name")
  end

  test ":process_not_found when trying to send a message to a non registered process", %{server: registry} do
    response = SimpleGenServer.put(registry, "non_registered_process", "a_message")

    assert :process_not_found == response
  end

  test ":ok when a message is saved to a registered process", %{server: registry} do
    SimpleGenServer.create(registry, "a_registered_process")
    response = SimpleGenServer.put(registry, "a_registered_process", "a_message")

    assert :ok == response
  end

  test ":process_not_found when trying to get a message from a non registered process", %{server: registry} do
    response = SimpleGenServer.get(registry, "non_registered_process", "a_message")

    assert :process_not_found == response
  end

  test ":message_not_found when trying to get a message that not exists", %{server: registry} do
    SimpleGenServer.create(registry, "a_registered_process")
    response = SimpleGenServer.get(registry, "a_registered_process", "a_message")

    assert :message_not_found == response
  end

  test "returns a saved message from a registered process", %{server: registry} do
    SimpleGenServer.create(registry, "a_registered_process")
    SimpleGenServer.put(registry, "a_registered_process", "a_message")
    response = SimpleGenServer.get(registry, "a_registered_process", "a_message")

    assert "stored_value" == response
  end

end
