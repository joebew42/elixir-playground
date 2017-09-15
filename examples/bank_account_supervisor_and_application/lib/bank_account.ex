defmodule BankAccount do
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
