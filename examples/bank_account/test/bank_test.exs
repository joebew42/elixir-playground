defmodule BankTest do
  use ExUnit.Case

  describe "when user does not exists" do
    test "we are not able to check current balance" do
      bank_pid = Bank.start()
      response = Bank.execute(bank_pid, {:current_balance_of, "non_existing_account"})

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to deposit" do
      bank_pid = Bank.start()
      response = Bank.execute(bank_pid, {:deposit, 1, "non_existing_account"})

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to withdrawal" do
      bank_pid = Bank.start()
      response = Bank.execute(bank_pid, {:withdrawal, 1, "non_existing_account"})

      assert {:error, :account_not_exists} == response
    end
  end

  describe "when user exists" do
    test "we are able to check the current balance" do
      bank_pid = Bank.start()
      response = Bank.execute(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1000} == response
    end

    test "we are able to deposit positive amounts" do
      bank_pid = Bank.start()
      Bank.execute(bank_pid, {:deposit, 50, "existing_account"})
      Bank.execute(bank_pid, {:deposit, 100, "existing_account"})
      Bank.execute(bank_pid, {:deposit, 200, "existing_account"})
      response = Bank.execute(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1000 + 50 + 100 + 200} == response
    end

    test "we are not able to deposit negative amounts" do
      bank_pid = Bank.start()
      Bank.execute(bank_pid, {:deposit, -100, "existing_account"})
      response = Bank.execute(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1000} == response
    end
  end

  test "returns error when a message cannot be handled" do
    bank_pid = Bank.start()
    response = Bank.execute(bank_pid, {:message_that_cannot_be_handled})

    assert {:error, :not_handled} = response
  end

end
