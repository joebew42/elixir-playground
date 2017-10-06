defmodule Bank.AccountTest do
  use ExUnit.Case, async: true

  test "we should be able to use different naming strategy" do
    {:ok, pid} = Bank.Account.start_link("a name", NamingStrategy.Null)

    assert true == is_pid(pid)
  end

  test "we should be able to use a registry as default naming strategy" do
    Bank.AccountRegistry.start_link([])
    {:ok, pid} = Bank.Account.start_link("a name")

    assert true == is_pid(pid)
  end
end
