defmodule KV.RegistryTest do
  use ExUnit.Case
  doctest KV.Registry

  setup do
    {:ok, registry} = start_supervised KV.Registry
    %{server: registry}
  end

  test ":ok and bucket id when a new bucket is registered", %{server: registry} do
    {:ok, bucket_id} = KV.Registry.create(registry, "a_new_name")

    assert Process.alive?(bucket_id)
  end

  test "returns :already_registered when a name is already registered", %{server: registry} do
    KV.Registry.create(registry, "same_name")

    assert :already_registered == KV.Registry.create(registry, "same_name")
  end

  test ":process_not_found when trying to send a message to a non registered process", %{server: registry} do
    response = KV.Registry.put(registry, "non_registered_process", "a_message")

    assert :process_not_found == response
  end

  test ":ok when a message is saved to a registered process", %{server: registry} do
    KV.Registry.create(registry, "a_registered_process")
    response = KV.Registry.put(registry, "a_registered_process", "a_message")

    assert :ok == response
  end

  test ":process_not_found when trying to get a message from a non registered process", %{server: registry} do
    response = KV.Registry.get(registry, "non_registered_process", "a_message")

    assert :process_not_found == response
  end

  test ":message_not_found when trying to get a message that not exists", %{server: registry} do
    KV.Registry.create(registry, "a_registered_process")
    response = KV.Registry.get(registry, "a_registered_process", "a_message")

    assert :message_not_found == response
  end

  test "returns a saved message from a registered process", %{server: registry} do
    KV.Registry.create(registry, "a_registered_process")
    KV.Registry.put(registry, "a_registered_process", "a_message")
    response = KV.Registry.get(registry, "a_registered_process", "a_message")

    assert "stored_value" == response
  end

  test ":process_not_found when trying to save a message in a dead bucket", %{server: registry} do
    {:ok, bucket_id} = KV.Registry.create(registry, "a_registered_process")
    Agent.stop(bucket_id)
    response = KV.Registry.put(registry, "a_registered_process", "a_message")

    assert :process_not_found == response
  end

end
