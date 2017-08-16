defmodule KV.RegistryTest do
  use ExUnit.Case
  doctest KV.Registry

  setup do
    {:ok, registry} = start_supervised KV.Registry
    %{server: registry}
  end

  test ":ok and bucket id when a new bucket is created", %{server: registry} do
    {:ok, bucket_id} = KV.Registry.create(registry, "a_bucket")

    assert Process.alive?(bucket_id)
  end

  test ":already_created when a bucket exists", %{server: registry} do
    KV.Registry.create(registry, "a_bucket")

    assert :already_created == KV.Registry.create(registry, "a_bucket")
  end

  test ":bucket_not_found when trying to save a message to a non existing bucket", %{server: registry} do
    response = KV.Registry.put(registry, "non_existing_bucket", "message_key", "message_value")

    assert :bucket_not_found == response
  end

  test ":ok when a message is saved to a bucket of messages", %{server: registry} do
    KV.Registry.create(registry, "bucket_of_messages")
    response = KV.Registry.put(registry, "bucket_of_messages", "a_message_key", "a_message_value")

    assert :ok == response
  end

  test ":bucket_not_found when trying to get a message from a non existing bucket", %{server: registry} do
    response = KV.Registry.get(registry, "non_existing_bucket", "a_message")

    assert :bucket_not_found == response
  end


  test ":message_not_found when trying to get a message that not exists", %{server: registry} do
    KV.Registry.create(registry, "a_registered_process")
    response = KV.Registry.get(registry, "a_registered_process", "a_message")

    assert :message_not_found == response
  end

  test "get a saved message from a bucket of messages", %{server: registry} do
    KV.Registry.create(registry, "a_bucket")
    KV.Registry.put(registry, "a_bucket", "test", "a test message")
    response = KV.Registry.get(registry, "a_bucket", "test")

    assert "a test message" == response
  end

  test ":bucket_not_found when trying to save a message in a dead bucket", %{server: registry} do
    {:ok, bucket_id} = KV.Registry.create(registry, "a_bucket")
    Agent.stop(bucket_id)
    response = KV.Registry.put(registry, "a_bucket", "message_key", "message_value")

    assert :bucket_not_found == response
  end

end
