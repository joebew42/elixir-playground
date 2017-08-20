defmodule BankTest do
  use ExUnit.Case

  describe "when user does not exists" do
    test "we are not able to check current balance" do
      bank_pid = Bank.start()
      response = Bank.query(bank_pid, {:current_balance_of, "non_existing_account"})

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to deposit money" do
      bank_pid = Bank.start()
      response = Bank.query(bank_pid, {:deposit, 100, "non_existing_account"})

      assert {:error, :account_not_exists} == response
    end
  end

  describe "when user exists" do
    test "we are able to check the current balance" do
      bank_pid = Bank.start()
      response = Bank.query(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1000} == response
    end

    test "we are able to deposit 100" do
      bank_pid = Bank.start()
      Bank.query(bank_pid, {:deposit, 100, "existing_account"})
      response = Bank.query(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1100} == response
    end

    test "we are able to deposit 200" do
      bank_pid = Bank.start()
      Bank.query(bank_pid, {:deposit, 200, "existing_account"})
      response = Bank.query(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1200} == response
    end

    test "we are not able to deposit negative amounts" do
      bank_pid = Bank.start()
      Bank.query(bank_pid, {:deposit, -100, "existing_account"})
      response = Bank.query(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1000} == response
    end
  end
end
