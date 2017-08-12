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

  def init(names) do
    {:ok, names}
  end

  def handle_call({:create, name}, _from, names) do
    if Map.has_key?(names, name) do
      {:reply, :already_registered, names}
    else
      {:reply, :ok, Map.put(names, name, true)}
    end
  end
end
