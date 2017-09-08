defmodule BankServer do
  def loop(accounts) do
    receive do
      {from, message} ->
        {reply, new_accounts} = handle(message, accounts)
        send from, reply
        loop(new_accounts)
    end
  end

  defp handle({:create_account, account}, accounts) do
    create_account(account, accounts)
  end

  defp handle({:delete_account, account}, accounts) do
    delete_account(account, accounts)
  end

  defp handle({:check_balance, account}, accounts) do
    check_balance(account, accounts)
  end

  defp handle({:deposit, amount, account}, accounts) do
    deposit(amount, account, accounts)
  end

  defp handle({:withdraw, amount, account}, accounts) do
    withdraw(amount, account, accounts)
  end

  defp create_account(account, accounts) do
    case exists?(account, accounts) do
      true -> {{:error, :account_already_exists}, accounts}
      false ->
        bank_account = BankAccount.start()
        new_accounts = Map.put(accounts, account, bank_account)
        {{:ok, :account_created}, new_accounts}
    end
  end

  defp delete_account(account, accounts) do
    case exists?(account, accounts) do
      false -> {{:error, :account_not_exists}, accounts}
      true ->
        bank_account = Map.get(accounts, account)
        if BankAccount.stop(bank_account) do
          {{:ok, :account_deleted}, Map.delete(accounts, account)}
        else
          {{:ok, :account_deleted}, accounts}
        end
    end
  end

  defp check_balance(account, accounts) do
    case exists?(account, accounts) do
      false -> {{:error, :account_not_exists}, accounts}
      true ->
        bank_account = Map.get(accounts, account)
        response = BankAccount.check_balance(bank_account)
        {{:ok, response}, accounts}
    end
  end

  defp deposit(amount, account, accounts) do
    case exists?(account, accounts) do
      false -> {{:error, :account_not_exists}, accounts}
      true ->
        bank_account = Map.get(accounts, account)
        BankAccount.deposit(bank_account, amount)
        {:ok, accounts}
    end
  end

  defp withdraw(amount, account, accounts) do
    case exists?(account, accounts) do
      false -> {{:error, :account_not_exists}, accounts}
      true ->
        bank_account = Map.get(accounts, account)
        response = BankAccount.withdraw(bank_account, amount)
        {response, accounts}
    end
  end

  defp exists?(account, accounts) do
    Map.has_key?(accounts, account)
  end
end
