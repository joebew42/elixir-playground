defmodule Bank do
  def start() do
    spawn(fn -> BankServer.loop(%{}) end)
  end

  def createAccount(bank_id, account) do
    execute(bank_id, {:create_account, account})
  end

  def deleteAccount(bank_id, account) do
    execute(bank_id, {:delete_account, account})
  end

  def checkBalance(bank_id, account) do
    execute(bank_id, {:check_balance, account})
  end

  def deposit(bank_id, amount, account) do
    execute(bank_id, {:deposit, amount, account})
  end

  def withdraw(bank_id, amount, account) do
    execute(bank_id, {:withdraw, amount, account})
  end

  defp execute(bank_pid, message) do
    send bank_pid, {self(), message}
    receive do
      reply -> reply
    end
  end
end
