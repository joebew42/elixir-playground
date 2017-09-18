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
end
