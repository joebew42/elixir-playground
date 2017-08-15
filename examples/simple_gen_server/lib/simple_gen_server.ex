defmodule SimpleGenServer do
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

  def put(pid, process_name, message) do
    GenServer.call(pid, {:put, process_name, message})
  end

  def get(pid, process_name, message) do
    GenServer.call(pid, {:get, process_name, message})
  end

  def init(names) do
    {:ok, names}
  end

  def handle_call({:create, name}, _from, {names, monitors}) do
    if registered?(name, names) do
      {:reply, :already_registered, {names, monitors}}
    else
      {:ok, bucket_id} = Bucket.start_link([])
      monitor = Process.monitor(bucket_id)
      monitors = Map.put(monitors, monitor, name)
      names = Map.put(names, name, bucket_id)
      {:reply, {:ok, bucket_id}, {names, monitors}}
    end
  end

  def handle_call({:put, name, message}, _from, {names, monitors}) do
    if registered?(name, names) do
      bucket = bucket_with(name, names)
      Bucket.put(bucket, message, "stored_value")
      {:reply, :ok, {names, monitors}}
    else
      {:reply, :process_not_found, {names, monitors}}
    end
  end

  def handle_call({:get, name, message}, _from, {names, monitors}) do
    if registered?(name, names) do
      bucket = bucket_with(name, names)
      {:reply, message_from(bucket, message), {names, monitors}}
    else
      {:reply, :process_not_found, {names, monitors}}
    end
  end

  def handle_info({:DOWN, monitor, :process, _pid, _reason}, {names, monitors}) do
    {name, monitors} = Map.pop(monitors, monitor)
    names = Map.delete(names, name)
    {:noreply, {names, monitors}}
  end

  def message_from(bucket, message) do
    response = Bucket.get(bucket, message)
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
