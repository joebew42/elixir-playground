defmodule BankServer do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def handle_call({:create_account, account}, _from, accounts) do
    create_account(account, accounts)
  end

  def handle_call({:delete_account, account}, _from, accounts) do
    delete_account(account, accounts)
  end

  def handle_call({:check_balance, account}, _from, accounts) do
    check_balance(account, accounts)
  end

  def handle_call({:deposit, amount, account}, _from, accounts) do
    deposit(amount, account, accounts)
  end

  def handle_call({:withdraw, amount, account}, _from, accounts) do
    withdraw(amount, account, accounts)
  end

  defp create_account(account, accounts) do
    case exists?(account, accounts) do
      true -> {:reply, {:error, :account_already_exists}, accounts}
      false ->
        bank_account = BankAccount.start()
        new_accounts = Map.put(accounts, account, bank_account)
        {:reply, {:ok, :account_created}, new_accounts}
    end
  end

  defp delete_account(account, accounts) do
    case exists?(account, accounts) do
      false -> {:reply, {:error, :account_not_exists}, accounts}
      true ->
        bank_account = Map.get(accounts, account)
        if BankAccount.stop(bank_account) do
          {:reply, {:ok, :account_deleted}, Map.delete(accounts, account)}
        else
          {:reply, {:ok, :account_deleted}, accounts}
        end
    end
  end

  defp check_balance(account, accounts) do
    case exists?(account, accounts) do
      false -> {:reply, {:error, :account_not_exists}, accounts}
      true ->
        bank_account = Map.get(accounts, account)
        response = BankAccount.check_balance(bank_account)
        {:reply, {:ok, response}, accounts}
    end
  end

  defp deposit(amount, account, accounts) do
    case exists?(account, accounts) do
      false -> {:reply, {:error, :account_not_exists}, accounts}
      true ->
        bank_account = Map.get(accounts, account)
        BankAccount.deposit(bank_account, amount)
        {:reply, :ok, accounts}
    end
  end

  defp withdraw(amount, account, accounts) do
    case exists?(account, accounts) do
      false -> {:reply, {:error, :account_not_exists}, accounts}
      true ->
        bank_account = Map.get(accounts, account)
        response = BankAccount.withdraw(bank_account, amount)
        {:reply, response, accounts}
    end
  end

  defp exists?(account, accounts) do
    Map.has_key?(accounts, account)
  end
end
