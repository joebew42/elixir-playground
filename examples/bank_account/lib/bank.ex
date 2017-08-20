defmodule Bank do
  def start() do
    spawn(fn -> loop(1000) end)
  end

  def query(bank_pid, {:current_balance_of, "existing_account"}) do
    send bank_pid, {self(), {:current_balance_of, "existing_account"}}
    receive do
      reply -> reply
    end
  end

  def query(_xxx, _yyy) do
    {:error, :account_not_exists}
  end

  defp loop(balance) do
    receive do
      {from, {:current_balance_of, "existing_account"}} ->
        send from, {:ok, balance}
    end
  end
end
