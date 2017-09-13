defmodule BankAccount do
  def start() do
    GenServer.start(BankAccountServer, 1000, [])
  end

  def stop(bank_account_pid) do
    GenServer.stop(bank_account_pid)
  end

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
end
