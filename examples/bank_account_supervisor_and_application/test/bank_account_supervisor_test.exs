defmodule BankAccountSupervisorTest do
  use ExUnit.Case, async: true

  setup do
    start_supervised BankAccountSupervisor
    start_supervised BankAccountRegistry
    %{}
  end

  test "when starting a bank account it will be registered with a name" do
    {:ok, bank_account_pid} = BankAccountSupervisor.start_bank_account("a name")

    registered_pid = BankAccountRegistry.whereis_name("a name")

    assert bank_account_pid == registered_pid
  end

  test "when stopping a bank account it will be unregistered" do
    {:ok, _} = BankAccountSupervisor.start_bank_account("a name")
    response = BankAccountSupervisor.stop_bank_account("a name")

    assert :ok == response
    assert :undefined == BankAccountRegistry.whereis_name("a name")
  end

  test "when a bank account crashes it will be created and registered with same name" do
    {:ok, bank_account_pid} = BankAccountSupervisor.start_bank_account("a name")
    Process.exit(bank_account_pid, :kill)
    Process.sleep(200)

    new_bank_account_pid = BankAccountRegistry.whereis_name("a name")

    assert true == is_pid(new_bank_account_pid)
    assert bank_account_pid != new_bank_account_pid
  end
end
