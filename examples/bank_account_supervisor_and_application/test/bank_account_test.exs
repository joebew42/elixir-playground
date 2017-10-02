defmodule BankAccountTest do
  use ExUnit.Case, async: true

  @tag :skip
  test "we are able to start a bank account" do
    {:ok, pid} = BankAccountServer.start_link("a name")

    assert true == is_pid(pid)
  end
end
