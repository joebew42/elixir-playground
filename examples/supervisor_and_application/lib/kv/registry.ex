defmodule KV.Registry do
  use GenServer

  @doc """
  start a new genserver
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, {%{}, %{}}, opts)
  end

  def create(pid, name) do
    GenServer.call(pid, {:create, name})
  end

  def put(pid, bucket_name, message_key, message_value) do
    GenServer.call(pid, {:put, bucket_name, message_key, message_value})
  end

  def get(pid, bucket_name, message) do
    GenServer.call(pid, {:get, bucket_name, message})
  end

  def handle_call({:create, name}, _from, {buckets, monitors}) do
    {response, buckets, monitors} = create_bucket(name, buckets, monitors)
    {:reply, response, {buckets, monitors}}
  end

  def handle_call({:put, bucket_name, message_key, message_value}, _from, {buckets, monitors}) do
    response = create_message(message_key, message_value, bucket_name, buckets)
    {:reply, response, {buckets, monitors}}
  end

  def handle_call({:get, name, message}, _from, {buckets, monitors}) do
    response = read_message(message, name, buckets)
    {:reply, response, {buckets, monitors}}
  end

  def handle_info({:DOWN, monitor, :process, _pid, _reason}, {buckets, monitors}) do
    {name, monitors} = Map.pop(monitors, monitor)
    buckets = Map.delete(buckets, name)
    {:noreply, {buckets, monitors}}
  end

  def create_bucket(name, buckets, monitors) do
    case exists?(name, buckets) do
      true ->
        {:already_created, buckets, monitors}
      _ ->
        {:ok, bucket_id} = KV.Bucket.start_link([])
        monitor = Process.monitor(bucket_id)
        monitors = Map.put(monitors, monitor, name)
        buckets = Map.put(buckets, name, bucket_id)
        {{:ok, bucket_id}, buckets, monitors}
    end
  end

  def create_message(message_key, message_value, bucket_name, buckets) do
    case exists?(bucket_name, buckets) do
      true ->
        bucket = bucket_with(bucket_name, buckets)
        KV.Bucket.put(bucket, message_key, message_value)
        :ok
      _ ->
        :bucket_not_found
    end
  end

  def read_message(message, name, buckets) do
    case exists?(name, buckets) do
      true ->
        bucket = bucket_with(name, buckets)
        message_from(bucket, message)
      _ ->
        :bucket_not_found
    end
  end

  def message_from(bucket, message_key) do
    response = KV.Bucket.get(bucket, message_key)
    if response == nil do
      :message_not_found
    else
      response
    end
  end

  def exists?(name, buckets) do
    Map.has_key?(buckets, name)
  end

  def bucket_with(name, buckets) do
    Map.get(buckets, name)
  end
end
