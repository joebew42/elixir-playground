defmodule Bank.Account do
  use GenServer

  def check_balance(bank_account_pid) do
    execute(bank_account_pid, {:check_balance})
  end

  def deposit(bank_account_pid, amount) do
    execute(bank_account_pid, {:deposit, amount})
  end

  def withdraw(bank_account_pid, amount) do
    execute(bank_account_pid, {:withdraw, amount})
  end

  defp execute(bank_account_pid, message) do
    GenServer.call(bank_account_pid, message)
  end

  def start_link(name, naming_strategy \\ NamingStrategy.Tuple) do
    GenServer.start_link(Bank.Account, 1000, name: naming_strategy.create(name))
  end

  def handle_call({:deposit, amount}, _from, balance) do
    {response, state} = _deposit(amount, balance)
    {:reply, response, state}
  end

  def handle_call({:withdraw, amount}, _from, balance) do
    {response, state} = _withdraw(amount, balance)
    {:reply, response, state}
  end

  def handle_call({:check_balance}, _from, balance) do
    {:reply, balance, balance}
  end

  defp _deposit(amount, balance) when amount > 0 do
    {:ok, balance + amount}
  end

  defp _deposit(_amount, balance) do
    {:ok, balance}
  end

  defp _withdraw(amount, balance) when amount >= 0 do
    new_balance = balance - amount
    case new_balance >= 0 do
      true -> {:ok, new_balance}
      false -> {{:error, :withdrawal_not_permitted}, balance}
    end
  end

  defp _withdraw(_amount, balance) do
    {{:error, :withdrawal_not_permitted}, balance}
  end
end
