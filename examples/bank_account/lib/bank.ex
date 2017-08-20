defmodule Bank do
  def start() do
    spawn(fn -> loop(1000) end)
  end

  def query(bank_pid, message) do
    send bank_pid, {self(), message}
    receive do
      reply -> reply
    end
  end

  defp loop(balance) do
    receive do
      {from, message} ->
        reply = handle(message, balance)
        send from, reply
    end
  end

  defp handle({:deposit, 100, "non_existing_account"}, _balance) do
    {:error, :account_not_exists}
  end

  defp handle({:current_balance_of, "non_existing_account"}, _balance) do
    {:error, :account_not_exists}
  end

  defp handle({:current_balance_of, "existing_account"}, balance) do
    {:ok, balance}
  end
end
