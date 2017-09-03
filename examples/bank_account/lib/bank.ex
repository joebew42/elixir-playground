defmodule Bank do
  def start() do
    spawn(fn -> loop(%{}) end)
  end

  def execute(bank_pid, message) do
    send bank_pid, {self(), message}
    receive do
      reply -> reply
    end
  end

  defp loop(accounts) do
    receive do
      {from, message} ->
        {reply, new_accounts} = handle(message, accounts)
        send from, reply
        loop(new_accounts)
    end
  end

  defp handle({:create_account, account}, accounts) do
    {response, new_accounts} = create_account(account, accounts)
    {response, new_accounts}
  end

  defp handle({:delete_account, account}, accounts) do
    case exists?(account, accounts) do
      false -> {{:error, :account_not_exists}, accounts}
      true -> {{:ok, :account_deleted}, Map.delete(accounts, account)}
    end
  end

  defp handle({:current_balance_of, account}, accounts) do
    case exists?(account, accounts) do
      false -> {{:error, :account_not_exists}, accounts}
      true -> {{:ok, current_balance_of(account, accounts)}, accounts}
    end
  end

  defp handle({:deposit, amount, account}, accounts) do
    case exists?(account, accounts) do
      false -> {{:error, :account_not_exists}, accounts}
      true -> {:ok, deposit(amount, account, accounts)}
    end
  end

  defp handle({:withdrawal, amount, account}, accounts) do
    case exists?(account, accounts) do
      false -> {{:error, :account_not_exists}, accounts}
      true ->
        {message, new_accounts} = withdrawal(amount, account, accounts)
        {message, new_accounts}
    end
  end

  defp handle(_message, accounts) do
    {{:error, :not_handled}, accounts}
  end

  defp create_account(account, accounts) do
    case exists?(account, accounts) do
      true -> {{:error, :account_already_exists}, accounts}
      false ->
        new_accounts = Map.put(accounts, account, 1000)
        {{:ok, :account_created}, new_accounts}
    end
  end

  def current_balance_of(account, accounts) do
    Map.get(accounts, account)
  end

  defp deposit(amount, account, accounts) do
    case amount > 0 do
      true ->
        new_balance = Map.get(accounts, account) + amount
        Map.put(accounts, account, new_balance)
      false -> accounts
    end
  end

  defp withdrawal(amount, _account, accounts) when amount < 0 do
    {{:error, :withdrawal_not_permitted}, accounts}
  end

  defp withdrawal(amount, account, accounts) when amount >= 0 do
    current_balance = Map.get(accounts, account)
    new_balance = current_balance - amount
    case new_balance >= 0 do
      true -> {:ok, Map.put(accounts, account, new_balance)}
      false -> {{:error, :withdrawal_not_permitted}, accounts}
    end
  end

  defp exists?(account, accounts) do
    Map.has_key?(accounts, account)
  end
end
