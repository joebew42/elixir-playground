defmodule BankAccountSupervisor do
  use Supervisor

  @name BankAccountSupervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    Supervisor.init([BankAccountServer], strategy: :simple_one_for_one)
  end

  def start_bank_account do
    Supervisor.start_child(@name, [])
  end

  def stop_bank_account(bank_account_pid) do
    GenServer.stop(bank_account_pid)
  end

end
