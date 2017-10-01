defmodule BankServer do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: :bank_server)
  end

  def handle_call({:create_account, account}, _from, state) do
    response = create_account(account)
    {:reply, response, state}
  end

  def handle_call({:delete_account, account}, _from, state) do
    response = delete_account(account)
    {:reply, response, state}
  end

  def handle_call({:check_balance, account}, _from, state) do
    response = check_balance(account)
    {:reply, response, state}
  end

  def handle_call({:deposit, amount, account}, _from, state) do
    response = deposit(amount, account)
    {:reply, response, state}
  end

  def handle_call({:withdraw, amount, account}, _from, state) do
    response = withdraw(amount, account)
    {:reply, response, state}
  end

  defp create_account(account) do
    case BankAccountRegistry.whereis_name(account) do
      :undefined ->
        {:ok, _} = BankAccountSupervisor.start_bank_account(account)
        {:ok, :account_created}
      _ -> {:error, :account_already_exists}
    end
  end

  defp delete_account(account) do
    case BankAccountRegistry.whereis_name(account) do
      :undefined -> {:error, :account_not_exists}
      _ ->
        :ok = BankAccountSupervisor.stop_bank_account(account)
        {:ok, :account_deleted}
    end
  end

  defp check_balance(account) do
    case BankAccountRegistry.whereis_name(account) do
      :undefined -> {:error, :account_not_exists}
      bank_account_pid ->
        current_balance = BankAccount.check_balance(bank_account_pid)
        {:ok, current_balance}
    end
  end

  defp deposit(amount, account) do
    case BankAccountRegistry.whereis_name(account) do
      :undefined -> {:error, :account_not_exists}
      bank_account_pid ->
        BankAccount.deposit(bank_account_pid, amount)
        {:ok}
    end
  end

  defp withdraw(amount, account) do
    case BankAccountRegistry.whereis_name(account) do
      :undefined -> {:error, :account_not_exists}
      bank_account_pid -> BankAccount.withdraw(bank_account_pid, amount)
    end
  end
end
