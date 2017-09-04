defmodule Bank do
  def start() do
    spawn(fn -> loop(%{}, %{}) end)
  end

  def execute(bank_pid, message) do
    send bank_pid, {self(), message}
    receive do
      reply -> reply
    end
  end

  defp loop(accounts, account_processes) do
    receive do
      {from, message} ->
        {reply, new_accounts, new_account_processes} = handle(message, accounts, account_processes)
        send from, reply
        loop(new_accounts, new_account_processes)
    end
  end

  defp handle({:create_account, account}, accounts, account_processes) do
    create_account(account, accounts, account_processes)
  end

  defp handle({:delete_account, account}, accounts, account_processes) do
    delete_account(account, accounts, account_processes)
  end

  defp handle({:current_balance_of, account}, accounts, account_processes) do
    case exists?(account, accounts, account_processes) do
      false -> {{:error, :account_not_exists}, accounts, account_processes}
      true -> {{:ok, current_balance_of(account, accounts, account_processes)}, accounts, account_processes}
    end
  end

  defp handle({:deposit, amount, account}, accounts, account_processes) do
    case exists?(account, accounts, account_processes) do
      false -> {{:error, :account_not_exists}, accounts, account_processes}
      true ->
        bank_account = Map.get(account_processes, account)
        BankAccount.execute(bank_account, {:deposit, amount})
        {:ok, deposit(amount, account, accounts), account_processes}
    end
  end

  defp handle({:withdrawal, amount, account}, accounts, account_processes) do
    case exists?(account, accounts, account_processes) do
      false -> {{:error, :account_not_exists}, accounts, account_processes}
      true ->
        {message, new_accounts, new_account_processes} = withdrawal(amount, account, accounts, account_processes)
        {message, new_accounts, new_account_processes}
    end
  end

  defp handle(_message, accounts, account_processes) do
    {{:error, :not_handled}, accounts, account_processes}
  end

  defp create_account(account, accounts, account_processes) do
    case exists?(account, accounts, account_processes) do
      true -> {{:error, :account_already_exists}, accounts, account_processes}
      false ->
        bank_account = BankAccount.start()
        new_account_processes = Map.put(account_processes, account, bank_account)
        new_accounts = Map.put(accounts, account, 1000)
        {{:ok, :account_created}, new_accounts, new_account_processes}
    end
  end

  defp delete_account(account, accounts, account_processes) do
    case exists?(account, accounts, account_processes) do
      false -> {{:error, :account_not_exists}, accounts, account_processes}
      true ->
        bank_account = Map.get(account_processes, account)
        if BankAccount.stop(bank_account) do
          {{:ok, :account_deleted}, Map.delete(accounts, account), Map.delete(account_processes, account)}
        else
          {{:ok, :account_deleted}, accounts, account_processes}
        end
    end
  end

  defp current_balance_of(account, _accounts, account_processes) do
    bank_account = Map.get(account_processes, account)
    BankAccount.execute(bank_account, {:balance})
  end

  defp deposit(amount, account, accounts) do
    case amount > 0 do
      true ->
        new_balance = Map.get(accounts, account) + amount
        Map.put(accounts, account, new_balance)
      false -> accounts
    end
  end

  defp withdrawal(amount, account, accounts, account_processes) do
    bank_account = Map.get(account_processes, account)
    response = BankAccount.execute(bank_account, {:withdrawal, amount})
    {response, accounts, account_processes}
  end

  defp exists?(account, accounts, account_processes) do
    Map.has_key?(accounts, account) or Map.has_key?(account_processes, account)
  end
end
