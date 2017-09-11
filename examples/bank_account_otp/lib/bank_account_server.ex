defmodule BankAccountServer do
  def loop(balance) do
    receive do
      {from, message} ->
        {response, new_balance} = handle(message, balance)
        send from, response
        loop(new_balance)
    end
  end

  defp handle({:deposit, amount}, balance) do
    deposit(amount, balance)
  end

  defp handle({:withdraw, amount}, balance) do
    withdraw(amount, balance)
  end

  defp handle({:check_balance}, balance) do
    {balance, balance}
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
