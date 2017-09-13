defmodule BankApplication do
  use Application

  def start(_type, _args) do
    BankSupervisor.start_link([])
  end
end
