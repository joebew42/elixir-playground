defmodule BankTest do
  use ExUnit.Case

  describe "when check the current balance" do
    test "we get an error if the account does not exist" do
      bank_pid = Bank.start()
      response = Bank.query(bank_pid, {:current_balance_of, "non_existing_account"})

      assert {:error, :account_not_exists} == response
    end

    test "we get the amount if the account exists" do
      bank_pid = Bank.start()
      response = Bank.query(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1000} == response
    end
  end

  describe "when deposit money" do
    test "we get an error if the account does not exist" do
      bank_pid = Bank.start()
      response = Bank.query(bank_pid, {:deposit, 100, "non_existing_account"})

      assert {:error, :account_not_exists} == response
    end

    test "the current balance will increase by 100 if the account exists" do
      bank_pid = Bank.start()
      Bank.query(bank_pid, {:deposit, 100, "existing_account"})
      response = Bank.query(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1100} == response
    end

    test "the current balance will increase by 200 if the account exists" do
      bank_pid = Bank.start()
      Bank.query(bank_pid, {:deposit, 200, "existing_account"})
      response = Bank.query(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1200} == response
    end

    test "the current balance will not change with negative amount" do
      bank_pid = Bank.start()
      Bank.query(bank_pid, {:deposit, -100, "existing_account"})
      response = Bank.query(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1000} == response
    end
  end

end
