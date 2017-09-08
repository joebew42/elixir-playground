defmodule BankAccount do
  def start() do
    spawn(fn -> loop(1000) end)
  end

  def stop(pid) do
    Process.exit(pid, :kill)
  end

  def check_balance(bank_account) do
    execute(bank_account, {:check_balance})
  end

  def deposit(bank_account, amount) do
    execute(bank_account, {:deposit, amount})
  end

  def withdraw(bank_account, amount) do
    execute(bank_account, {:withdraw, amount})
  end

  defp execute(pid, message) do
    send pid, {self(), message}
    receive do
      reply -> reply
    end
  end

  defp loop(balance) do
    receive do
      {from, message} ->
        {response, new_balance} = handle(message, balance)
        send from, response
        loop(new_balance)
    end
  end

  defp handle({:deposit, amount}, balance) do
    server_deposit(amount, balance)
  end

  defp handle({:withdraw, amount}, balance) do
    server_withdraw(amount, balance)
  end

  defp handle({:check_balance}, balance) do
    {balance, balance}
  end

  defp server_deposit(amount, balance) when amount > 0 do
    {:ok, balance + amount}
  end

  defp server_deposit(_amount, balance) do
    {:ok, balance}
  end

  defp server_withdraw(amount, balance) when amount >= 0 do
    new_balance = balance - amount
    case new_balance >= 0 do
      true -> {:ok, new_balance}
      false -> {{:error, :withdrawal_not_permitted}, balance}
    end
  end

  defp server_withdraw(_amount, balance) do
    {{:error, :withdrawal_not_permitted}, balance}
  end

end
