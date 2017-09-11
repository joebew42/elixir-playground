defmodule Bank do
  def start() do
    spawn(fn -> BankServer.loop(%{}) end)
  end

  def create_account(bank_pid, account) do
    execute(bank_pid, {:create_account, account})
  end

  def delete_account(bank_pid, account) do
    execute(bank_pid, {:delete_account, account})
  end

  def check_balance(bank_pid, account) do
    execute(bank_pid, {:check_balance, account})
  end

  def deposit(bank_pid, amount, account) do
    execute(bank_pid, {:deposit, amount, account})
  end

  def withdraw(bank_pid, amount, account) do
    execute(bank_pid, {:withdraw, amount, account})
  end

  defp execute(bank_pid, message) do
    send bank_pid, {self(), message}
    receive do
      reply -> reply
    end
  end
end
