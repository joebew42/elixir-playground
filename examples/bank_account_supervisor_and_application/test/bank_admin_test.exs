defmodule BankAdminTest do
  use ExUnit.Case, async: true

  describe "when account does not exists" do

    setup do
      start_supervised BankAccountSupervisor
      start_supervised BankAccountRegistry

      start_supervised BankAdmin

      %{}
    end

    test "we are able to create a new account" do
      response = BankAdmin.create_account("an_account")

      assert {:ok, :account_created} == response
    end

    test "we are not able to delete an account" do
      response = BankAdmin.delete_account("non_existing_account")

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to check current balance" do
      response = BankAdmin.check_balance("non_existing_account")

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to deposit" do
      response = BankAdmin.deposit(1, "non_existing_account")

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to withdraw" do
      response = BankAdmin.withdraw(1, "non_existing_account")

      assert {:error, :account_not_exists} == response
    end
  end

  describe "when account exists" do

    setup do
      start_supervised BankAccountSupervisor
      start_supervised BankAccountRegistry
      start_supervised BankAdmin

      BankAdmin.create_account("existing_account")
      BankAdmin.create_account("other_existing_account")

      %{}
    end

    test "we are not able to create an account with the same name" do
      response = BankAdmin.create_account("existing_account")

      assert {:error, :account_already_exists} == response
    end

    test "we are able to delete an account" do
      response_account_deleted = BankAdmin.delete_account("existing_account")
      response_account_not_exists = BankAdmin.delete_account("existing_account")

      assert {:ok, :account_deleted} == response_account_deleted
      assert {:error, :account_not_exists} == response_account_not_exists
    end

    test "we are able to check the current balance" do
      response = BankAdmin.check_balance("existing_account")

      assert {:ok, 1000} == response
    end

    test "we are able to deposit positive amounts" do
      BankAdmin.deposit(50, "existing_account")
      BankAdmin.deposit(100, "existing_account")
      BankAdmin.deposit(200, "existing_account")
      response = BankAdmin.check_balance("existing_account")

      assert {:ok, 1000 + 50 + 100 + 200} == response
    end

    test "we are not able to deposit negative amounts" do
      BankAdmin.deposit(-100, "existing_account")
      response = BankAdmin.check_balance("existing_account")

      assert {:ok, 1000} == response
    end

    test "we are not able to withdraw if the amount is greater than current balance" do
      response = BankAdmin.withdraw(1001, "existing_account")

      assert {:error, :withdrawal_not_permitted} == response
    end

    test "we are not able to withdraw a negative amount" do
      response = BankAdmin.withdraw(-1, "existing_account")

      assert {:error, :withdrawal_not_permitted} == response
    end

    test "we are able to withdraw if the amount is lower or equal than current balance" do
      BankAdmin.withdraw(1000, "existing_account")
      response = BankAdmin.check_balance("existing_account")

      assert {:ok, 0} == response
    end

    test "we are able to perform actions on different accounts" do
      BankAdmin.deposit(100, "existing_account")
      BankAdmin.withdraw(100, "other_existing_account")

      assert {:ok, 1100} == BankAdmin.check_balance("existing_account")
      assert {:ok, 900} == BankAdmin.check_balance("other_existing_account")
    end
  end

end
