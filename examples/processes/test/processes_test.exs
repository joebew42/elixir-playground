defmodule ProcessesTest do
  use ExUnit.Case

  test "process is alive once is started" do
    pid = Processes.start

    assert true == Process.alive? pid
  end

  test "return the current account balance" do
    pid = Processes.start

    response = Processes.call(pid, {:get, :account_balance})

    assert 1000 == response
  end

  test "deposit 100 will increase the account balance to 1100" do
    pid = Processes.start
    Processes.call(pid, {:deposit, :account_balance, 100})
    response = Processes.call(pid, {:get, :account_balance})

    assert 1100 == response
  end
end
