defmodule Bank do
  def create_account(account) do
    execute({:create_account, account})
  end

  def delete_account(account) do
    execute({:delete_account, account})
  end

  def check_balance(account) do
    execute({:check_balance, account})
  end

  def deposit(amount, account) do
    execute({:deposit, amount, account})
  end

  def withdraw(amount, account) do
    execute({:withdraw, amount, account})
  end

  defp execute(message) do
    GenServer.call(:bank_server, message)
  end
end
