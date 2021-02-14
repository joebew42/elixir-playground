defmodule Processes do
  def start do
    spawn(fn -> loop(%{balance: 1000}) end)
  end

  def call(pid, {:get, :account_balance}) do
    send(pid, {self(), {:get, :account_balance}})

    receive do
      account_balance -> account_balance
    end
  end

  def call(pid, {:deposit, :account_balance, amount}) do
    send(pid, {self(), {:deposit, :account_balance, amount}})

    receive do
      reply -> reply
    end
  end

  defp loop(account) do
    receive do
      {from, {:deposit, :account_balance, amount}} ->
        current_amount = Map.get(account, :balance)
        updated_account = Map.put(account, :balance, current_amount + amount)
        send(from, :ok)
        loop(updated_account)

      {from, {:get, :account_balance}} ->
        balance = Map.get(account, :balance)
        send(from, balance)
        loop(account)

      _ ->
        loop(account)
    end
  end
end
