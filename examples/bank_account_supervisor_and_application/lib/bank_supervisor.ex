defmodule BankSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Bank.Admin,
      BankAccountSupervisor,
      BankAccountRegistry
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
