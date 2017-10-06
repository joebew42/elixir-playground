defmodule Bank.Admin do
  use GenServer

  def create_account(account) do
    send({:create_account, account})
  end

  def delete_account(account) do
    send({:delete_account, account})
  end

  def check_balance(account) do
    send({:check_balance, account})
  end

  def deposit(amount, account) do
    send({:deposit, amount, account})
  end

  def withdraw(amount, account) do
    send({:withdraw, amount, account})
  end

  defp send(message) do
    GenServer.call(:bank_server, message)
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: :bank_server)
  end

  def handle_call({:create_account, account}, _from, state) do
    response = _create_account(account)
    {:reply, response, state}
  end

  def handle_call({:delete_account, account}, _from, state) do
    response = _delete_account(account)
    {:reply, response, state}
  end

  def handle_call({:check_balance, account}, _from, state) do
    response = _check_balance(account)
    {:reply, response, state}
  end

  def handle_call({:deposit, amount, account}, _from, state) do
    response = _deposit(amount, account)
    {:reply, response, state}
  end

  def handle_call({:withdraw, amount, account}, _from, state) do
    response = _withdraw(amount, account)
    {:reply, response, state}
  end

  defp _create_account(account) do
    case Bank.AccountRegistry.whereis_name(account) do
      :undefined ->
        {:ok, _} = BankAccountSupervisor.start_bank_account(account)
        {:ok, :account_created}
      _ -> {:error, :account_already_exists}
    end
  end

  defp _delete_account(account) do
    case Bank.AccountRegistry.whereis_name(account) do
      :undefined -> {:error, :account_not_exists}
      _ ->
        :ok = BankAccountSupervisor.stop_bank_account(account)
        {:ok, :account_deleted}
    end
  end

  defp _check_balance(account) do
    case Bank.AccountRegistry.whereis_name(account) do
      :undefined -> {:error, :account_not_exists}
      bank_account_pid ->
        current_balance = Bank.Account.check_balance(bank_account_pid)
        {:ok, current_balance}
    end
  end

  defp _deposit(amount, account) do
    case Bank.AccountRegistry.whereis_name(account) do
      :undefined -> {:error, :account_not_exists}
      bank_account_pid ->
        Bank.Account.deposit(bank_account_pid, amount)
        {:ok}
    end
  end

  defp _withdraw(amount, account) do
    case Bank.AccountRegistry.whereis_name(account) do
      :undefined -> {:error, :account_not_exists}
      bank_account_pid -> Bank.Account.withdraw(bank_account_pid, amount)
    end
  end
end
