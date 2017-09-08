defmodule BankServer do
  def loop(account_processes) do
    receive do
      {from, message} ->
        {reply, new_account_processes} = handle(message, account_processes)
        send from, reply
        loop(new_account_processes)
    end
  end

  defp handle({:create_account, account}, account_processes) do
    create_account(account, account_processes)
  end

  defp handle({:delete_account, account}, account_processes) do
    delete_account(account, account_processes)
  end

  defp handle({:check_balance, account}, account_processes) do
    check_balance(account, account_processes)
  end

  defp handle({:deposit, amount, account}, account_processes) do
    deposit(amount, account, account_processes)
  end

  defp handle({:withdraw, amount, account}, account_processes) do
    withdraw(amount, account, account_processes)
  end

  defp create_account(account, account_processes) do
    case exists?(account, account_processes) do
      true -> {{:error, :account_already_exists}, account_processes}
      false ->
        bank_account = BankAccount.start()
        new_account_processes = Map.put(account_processes, account, bank_account)
        {{:ok, :account_created}, new_account_processes}
    end
  end

  defp delete_account(account, account_processes) do
    case exists?(account, account_processes) do
      false -> {{:error, :account_not_exists}, account_processes}
      true ->
        bank_account = Map.get(account_processes, account)
        if BankAccount.stop(bank_account) do
          {{:ok, :account_deleted}, Map.delete(account_processes, account)}
        else
          {{:ok, :account_deleted}, account_processes}
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

  defp exists?(account, account_processes) do
    Map.has_key?(account_processes, account)
  end
end
