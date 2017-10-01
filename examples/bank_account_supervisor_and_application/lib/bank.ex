defmodule Bank do
  def create_account(account) do
    send({:create_account, account})
  end

  def delete_account(account) do
    send({:delete_account, account})
  end

  def check_balance(account) do
    send({:check_balance, account})
  end

  def deposit(amount, account) do
    send({:deposit, amount, account})
  end

  def withdraw(amount, account) do
    send({:withdraw, amount, account})
  end

  defp send(message) do
    GenServer.call(:bank_server, message)
  end
end
