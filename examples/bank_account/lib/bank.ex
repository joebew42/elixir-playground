defmodule Bank do
  def start() do
    spawn(fn -> loop(1000) end)
  end

  def execute(bank_pid, message) do
    send bank_pid, {self(), message}
    receive do
      reply -> reply
    end
  end

  defp loop(balance) do
    receive do
      {from, message} ->
        {reply, new_balance} = handle(message, balance)
        send from, reply
        loop(new_balance)
    end
  end

  defp handle({:deposit, _amount, "non_existing_account"}, balance) do
    {{:error, :account_not_exists}, balance}
  end

  defp handle({:deposit, amount, "existing_account"}, balance) do
    case amount > 0 do
      true ->
        new_balance = balance + amount
        {:ok, new_balance}
      false ->
        {:ok, balance}
    end
  end

  defp handle({:withdrawal, _amount, "non_existing_account"}, balance) do
    {{:error, :account_not_exists}, balance}
  end

  defp handle({:current_balance_of, "non_existing_account"}, balance) do
    {{:error, :account_not_exists}, balance}
  end

  defp handle({:current_balance_of, "existing_account"}, balance) do
    {{:ok, balance}, balance}
  end

  defp handle(_message, balance) do
    {{:error, :not_handled}, balance}
  end
end
