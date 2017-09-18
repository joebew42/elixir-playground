defmodule BankAccountRegistry do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def whereis_name(_name) do
    {:reply, :undefined, %{}}
  end
end
