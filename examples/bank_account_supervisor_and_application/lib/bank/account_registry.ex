defmodule Bank.AccountRegistry do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: :registry)
  end

  def whereis_name(name) do
    GenServer.call(:registry, {:whereis_name, name})
  end

  def register_name(name, pid) do
    GenServer.call(:registry, {:register_name, name, pid})
  end

  def unregister_name(name) do
    GenServer.cast(:registry, {:unregister_name, name})
  end

  def send(name, message) do
    case whereis_name(name) do
      :undefined -> {:badarg, {name, message}}
      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:whereis_name, name}, _from, names) do
    {:reply, Map.get(names, name, :undefined), names}
  end

  def handle_call({:register_name, name, pid}, _from, names) do
    case Map.has_key?(names, name) do
      true -> {:reply, :no, names}
      false ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(names, name, pid)}
    end
  end

  def handle_cast({:unregister_name, name}, names) do
    {:noreply, Map.delete(names, name)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, names) do
    {:noreply, remove(pid, names)}
  end

  defp remove(pid_to_remove, names) do
    names
    |> Enum.filter(fn {_name, pid} -> pid != pid_to_remove end)
    |> Enum.into(%{})
  end
end
