defmodule BankAccountRegistryTest do
  use ExUnit.Case

  setup do
    start_supervised BankAccountRegistry
    %{}
  end

  test "returns undefined when there is no registered process" do
    response = BankAccountRegistry.whereis_name("non_registered")

    assert {:reply, :undefined, %{}} == response
  end

  test "returns the process id of a registered process" do
    BankAccountRegistry.register_name("registered", :a_process_id)

    response = BankAccountRegistry.whereis_name("registered")

    assert {:reply, :a_process_id, %{registered: :a_process_id}}
  end
end
