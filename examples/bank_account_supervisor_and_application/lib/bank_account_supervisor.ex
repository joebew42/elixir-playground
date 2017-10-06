defmodule BankAccountSupervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, [], name: :bank_account_supervisor)
  end

  def init(_) do
    children = [
      worker(Bank.Account, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def start_bank_account(name) do
    Supervisor.start_child(:bank_account_supervisor, [name])
  end

  def stop_bank_account(name) do
    Supervisor.terminate_child(:bank_account_supervisor, Bank.AccountRegistry.whereis_name(name))
  end

end
