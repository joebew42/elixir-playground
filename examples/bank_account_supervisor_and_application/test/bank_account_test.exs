defmodule BankAccountTest do
  use ExUnit.Case, async: true

  test "we should be able to use different naming strategy" do
    {:ok, pid} = BankAccount.start_link("a name", NullNameStrategy)

    assert true == is_pid(pid)
  end

  test "we should be able to use a registry as default naming strategy" do
    BankAccountRegistry.start_link([])
    {:ok, pid} = BankAccount.start_link("a name")

    assert true == is_pid(pid)
  end
end
