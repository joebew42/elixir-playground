defmodule BankAccountTest do
  use ExUnit.Case, async: true

  @tag :skip
  test "we should be able to start a bank account process" do
    {:ok, pid} = BankAccountServer.start_link("a name")

    assert true == is_pid(pid)
  end
end
