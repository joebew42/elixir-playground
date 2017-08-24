defmodule Bank do
  def start() do
    spawn(fn -> loop(1000, %{}) end)
  end

  def execute(bank_pid, message) do
    send bank_pid, {self(), message}
    receive do
      reply -> reply
    end
  end

  defp loop(balance, accounts) do
    receive do
      {from, message} ->
        {reply, new_balance, new_accounts} = handle(message, balance, accounts)
        send from, reply
        loop(new_balance, new_accounts)
    end
  end

  defp handle({:create_account, account}, balance, accounts) do
    {response, new_accounts} = create_account(account, accounts)
    {response, balance, new_accounts}
  end

  defp handle({:deposit, _amount, "non_existing_account"}, balance, accounts) do
    {{:error, :account_not_exists}, balance, accounts}
  end

  defp handle({:deposit, amount, "existing_account"}, balance, accounts) do
    case amount > 0 do
      true ->
        new_balance = balance + amount
        {:ok, new_balance, accounts}
      false ->
        {:ok, balance, accounts}
    end
  end

  defp handle({:withdrawal, _amount, "non_existing_account"}, balance, accounts) do
    {{:error, :account_not_exists}, balance, accounts}
  end

  defp handle({:withdrawal, amount, "existing_account"}, balance, accounts) when amount < 0 do
    {{:error, :withdrawal_not_permitted}, balance, accounts}
  end

  defp handle({:withdrawal, amount, "existing_account"}, balance, accounts) when amount >= 0 do
    new_balance = balance - amount
    case new_balance >= 0 do
      true ->
        {:ok, new_balance, accounts}
      false ->
        {{:error, :withdrawal_not_permitted}, balance, accounts}
    end
  end

  defp handle({:current_balance_of, "non_existing_account"}, balance, accounts) do
    {{:error, :account_not_exists}, balance, accounts}
  end

  defp handle({:current_balance_of, "existing_account"}, balance, accounts) do
    {{:ok, balance}, balance, accounts}
  end

  defp handle(_message, balance, accounts) do
    {{:error, :not_handled}, balance, accounts}
  end

  defp create_account(account, accounts) do
    case exists?(account, accounts) do
      true -> {{:error, :account_already_exists}, accounts}
      false ->
        new_accounts = Map.put(accounts, account, nil)
        {{:ok, :account_created}, new_accounts}
    end
  end

  defp exists?(account, accounts) do
    Map.has_key?(accounts, account)
  end
end
