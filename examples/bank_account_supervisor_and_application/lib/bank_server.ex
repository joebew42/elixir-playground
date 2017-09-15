defmodule BankServer do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def handle_call({:create_account, account}, _from, accounts) do
    {response, state} = create_account(account, accounts)
    {:reply, response, state}
  end

  def handle_call({:delete_account, account}, _from, accounts) do
    {response, state} = delete_account(account, accounts)
    {:reply, response, state}
  end

  def handle_call({:check_balance, account}, _from, accounts) do
    {response, state} = check_balance(account, accounts)
    {:reply, response, state}
  end

  def handle_call({:deposit, amount, account}, _from, accounts) do
    {response, state} = deposit(amount, account, accounts)
    {:reply, response, state}
  end

  def handle_call({:withdraw, amount, account}, _from, accounts) do
    {response, state} = withdraw(amount, account, accounts)
    {:reply, response, state}
  end

  defp create_account(account, accounts) do
    case exists?(account, accounts) do
      true -> {{:error, :account_already_exists}, accounts}
      false ->
        {:ok, bank_account} = BankAccountSupervisor.start_bank_account()
        new_accounts = Map.put(accounts, account, bank_account)
        {{:ok, :account_created}, new_accounts}
    end
  end

  defp delete_account(account, accounts) do
    case exists?(account, accounts) do
      false -> {{:error, :account_not_exists}, accounts}
      true ->
        bank_account = Map.get(accounts, account)
        if BankAccountSupervisor.stop_bank_account(bank_account) do
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
