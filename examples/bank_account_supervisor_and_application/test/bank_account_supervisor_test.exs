defmodule BankAccountSupervisorTest do
  use ExUnit.Case

  setup do
    BankAccountRegistry.start_link([])
    BankAccountSupervisor.start_link([])
    %{}
  end

  test "when starting a bank account it will be registered with a name" do
    {:ok, bank_account_pid} = BankAccountSupervisor.start_bank_account("a name")

    registered_pid = BankAccountRegistry.whereis_name("a name")

    assert bank_account_pid == registered_pid
  end
end
