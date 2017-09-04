defmodule BankAccount do
  def start() do
    spawn(fn -> loop(1000) end)
  end

  def stop(pid) do
    Process.exit(pid, :kill)
  end

  def execute(pid, message) do
    send pid, {self(), message}
    receive do
      reply -> reply
    end
  end

  defp loop(balance) do
    receive do
      {from, {:deposit, amount}} ->
        {response, new_balance} = deposit(amount, balance)
        send from, :ok
        loop(new_balance)
      {from, {:withdrawal, amount}} ->
        {response, new_balance} = withdrawal(amount, balance)
        send from, response
        loop(new_balance)
      {from, {:balance}} ->
        send from, balance
        loop(balance)
    end
  end

  defp deposit(amount, balance) when amount > 0 do
    {:ok, balance + amount}
  end

  defp deposit(_amount, balance) do
    {:ok, balance}
  end

  defp withdrawal(amount, balance) when amount >= 0 do
    new_balance = balance - amount
    case new_balance >= 0 do
      true -> {:ok, new_balance}
      false -> {{:error, :withdrawal_not_permitted}, balance}
    end
  end

  defp withdrawal(_amount, balance) do
    {{:error, :withdrawal_not_permitted}, balance}
  end

end
