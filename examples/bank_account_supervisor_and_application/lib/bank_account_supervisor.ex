defmodule BankAccountSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    children = [
      worker(BankAccountServer, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def start_bank_account(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  def start_bank_account do
    Supervisor.start_child(__MODULE__, [])
  end

  def stop_bank_account(bank_account_pid) do
    GenServer.stop(bank_account_pid)
  end

end
