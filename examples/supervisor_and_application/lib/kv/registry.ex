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

  def get(pid, process_name, message) do
    GenServer.call(pid, {:get, process_name, message})
  end

  def init(names) do
    {:ok, names}
  end

  def handle_call({:create, name}, _from, {names, monitors}) do
    {response, names, monitors} = create_bucket(name, names, monitors)
    {:reply, response, {names, monitors}}
  end

  def handle_call({:put, bucket_name, message_key, message_value}, _from, {names, monitors}) do
    response = create_message(message_key, message_value, bucket_name, names)
    {:reply, response, {names, monitors}}
  end

  def handle_call({:get, name, message}, _from, {names, monitors}) do
    response = read_message(message, name, names)
    {:reply, response, {names, monitors}}
  end

  def handle_info({:DOWN, monitor, :process, _pid, _reason}, {names, monitors}) do
    {name, monitors} = Map.pop(monitors, monitor)
    names = Map.delete(names, name)
    {:noreply, {names, monitors}}
  end

  def create_bucket(name, names, monitors) do
    case registered?(name, names) do
      true ->
        {:already_registered, names, monitors}
      _ ->
        {:ok, bucket_id} = KV.Bucket.start_link([])
        monitor = Process.monitor(bucket_id)
        monitors = Map.put(monitors, monitor, name)
        names = Map.put(names, name, bucket_id)
        {{:ok, bucket_id}, names, monitors}
    end
  end

  def create_message(message_key, message_value, bucket_name, names) do
    case registered?(bucket_name, names) do
      true ->
        bucket = bucket_with(bucket_name, names)
        KV.Bucket.put(bucket, message_key, message_value)
        :ok
      _ ->
        :process_not_found
    end
  end

  def read_message(message, name, names) do
    case registered?(name, names) do
      true ->
        bucket = bucket_with(name, names)
        message_from(bucket, message)
      _ ->
        :process_not_found
    end
  end

  def message_from(bucket, message) do
    response = KV.Bucket.get(bucket, message)
    if response == nil do
      :message_not_found
    else
      response
    end
  end

  def registered?(name, names) do
    Map.has_key?(names, name)
  end

  def bucket_with(name, names) do
    Map.get(names, name)
  end
end
