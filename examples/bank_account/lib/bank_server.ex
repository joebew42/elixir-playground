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
    case exists?(account, account_processes) do
      false -> {{:error, :account_not_exists}, account_processes}
      true -> {{:ok, check_balance(account, account_processes)}, account_processes}
    end
  end

  defp handle({:deposit, amount, account}, account_processes) do
    case exists?(account, account_processes) do
      false -> {{:error, :account_not_exists}, account_processes}
      true ->
        bank_account = Map.get(account_processes, account)
        BankAccount.execute(bank_account, {:deposit, amount})
        {:ok, account_processes}
    end
  end

  defp handle({:withdraw, amount, account}, account_processes) do
    case exists?(account, account_processes) do
      false -> {{:error, :account_not_exists}, account_processes}
      true -> server_withdraw(amount, account, account_processes)
    end
  end

  defp handle(_message, account_processes) do
    {{:error, :not_handled}, account_processes}
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

  defp check_balance(account, account_processes) do
    bank_account = Map.get(account_processes, account)
    BankAccount.execute(bank_account, {:check_balance})
  end

  defp server_withdraw(amount, account, account_processes) do
    bank_account = Map.get(account_processes, account)
    response = BankAccount.execute(bank_account, {:withdraw, amount})
    {response, account_processes}
  end

  defp exists?(account, account_processes) do
    Map.has_key?(account_processes, account)
  end
end
