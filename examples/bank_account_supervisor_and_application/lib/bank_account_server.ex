defmodule BankAccountServer do
  use GenServer

  @naming_strategy Application.get_env(:bank, :naming_strategy)

  def start_link(name) do
    GenServer.start_link(BankAccountServer, 1000, name: @naming_strategy.create(name))
  end

  def handle_call({:deposit, amount}, _from, balance) do
    {response, state} = deposit(amount, balance)
    {:reply, response, state}
  end

  def handle_call({:withdraw, amount}, _from, balance) do
    {response, state} = withdraw(amount, balance)
    {:reply, response, state}
  end

  def handle_call({:check_balance}, _from, balance) do
    {:reply, balance, balance}
  end

  defp deposit(amount, balance) when amount > 0 do
    {:ok, balance + amount}
  end

  defp deposit(_amount, balance) do
    {:ok, balance}
  end

  defp withdraw(amount, balance) when amount >= 0 do
    new_balance = balance - amount
    case new_balance >= 0 do
      true -> {:ok, new_balance}
      false -> {{:error, :withdrawal_not_permitted}, balance}
    end
  end

  defp withdraw(_amount, balance) do
    {{:error, :withdrawal_not_permitted}, balance}
  end
end
