defmodule SimpleGenServer do
  use GenServer

  @doc """
  start a new genserver
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
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

  def handle_call({:create, name}, _from, names) do
    if registered?(name, names) do
      {:reply, :already_registered, names}
    else
      {:ok, bucket_pid} = Bucket.start_link([])
      {:reply, :ok, Map.put(names, name, bucket_pid)}
    end
  end

  def handle_call({:put, name, message}, _from, names) do
    if registered?(name, names) do
      bucket = bucket_with(name, names)
      Bucket.put(bucket, message, "stored_value")
      {:reply, :ok, names}
    else
      {:reply, :process_not_found, names}
    end
  end

  def handle_call({:get, name, message}, _from, names) do
    if registered?(name, names) do
      bucket = bucket_with(name, names)
      response = Bucket.get(bucket, message)
      if response == nil do
        {:reply, :message_not_found, names}
      else
        {:reply, response, names}
      end
    else
      {:reply, :process_not_found, names}
    end
  end

  def registered?(name, names) do
    Map.has_key?(names, name)
  end

  def bucket_with(name, names) do
    Map.get(names, name)
  end
end
