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

  def init(names) do
    {:ok, names}
  end

  def handle_call({:create, name}, _from, names) do
    if registered?(name, names) do
      {:reply, :already_registered, names}
    else
      {:reply, :ok, Map.put(names, name, true)}
    end
  end

  def handle_call({:put, name, _message}, _from, names) do
    if registered?(name, names) do
      {:reply, :ok, names}
    else
      {:reply, :process_not_found, names}
    end
  end

  def registered?(name, names) do
    Map.has_key?(names, name)
  end
end
