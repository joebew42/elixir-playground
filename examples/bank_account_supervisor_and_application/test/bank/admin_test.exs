defmodule Bank.AdminTest do
  use ExUnit.Case, async: true

  describe "when account does not exists" do

    setup do
      start_supervised Bank.AccountSupervisor
      start_supervised Bank.AccountRegistry

      start_supervised Bank.Admin

      %{}
    end

    test "we are able to create a new account" do
      response = Bank.Admin.create_account("an_account")

      assert {:ok, :account_created} == response
    end

    test "we are not able to delete an account" do
      response = Bank.Admin.delete_account("non_existing_account")

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to check current balance" do
      response = Bank.Admin.check_balance("non_existing_account")

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to deposit" do
      response = Bank.Admin.deposit(1, "non_existing_account")

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to withdraw" do
      response = Bank.Admin.withdraw(1, "non_existing_account")

      assert {:error, :account_not_exists} == response
    end
  end

  describe "when account exists" do

    setup do
      start_supervised Bank.AccountSupervisor
      start_supervised Bank.AccountRegistry
      start_supervised Bank.Admin

      Bank.Admin.create_account("existing_account")
      Bank.Admin.create_account("other_existing_account")

      %{}
    end

    test "we are not able to create an account with the same name" do
      response = Bank.Admin.create_account("existing_account")

      assert {:error, :account_already_exists} == response
    end

    test "we are able to delete an account" do
      response_account_deleted = Bank.Admin.delete_account("existing_account")
      response_account_not_exists = Bank.Admin.delete_account("existing_account")

      assert {:ok, :account_deleted} == response_account_deleted
      assert {:error, :account_not_exists} == response_account_not_exists
    end

    test "we are able to check the current balance" do
      response = Bank.Admin.check_balance("existing_account")

      assert {:ok, 1000} == response
    end

    test "we are able to deposit positive amounts" do
      Bank.Admin.deposit(50, "existing_account")
      Bank.Admin.deposit(100, "existing_account")
      Bank.Admin.deposit(200, "existing_account")
      response = Bank.Admin.check_balance("existing_account")

      assert {:ok, 1000 + 50 + 100 + 200} == response
    end

    test "we are not able to deposit negative amounts" do
      Bank.Admin.deposit(-100, "existing_account")
      response = Bank.Admin.check_balance("existing_account")

      assert {:ok, 1000} == response
    end

    test "we are not able to withdraw if the amount is greater than current balance" do
      response = Bank.Admin.withdraw(1001, "existing_account")

      assert {:error, :withdrawal_not_permitted} == response
    end

    test "we are not able to withdraw a negative amount" do
      response = Bank.Admin.withdraw(-1, "existing_account")

      assert {:error, :withdrawal_not_permitted} == response
    end

    test "we are able to withdraw if the amount is lower or equal than current balance" do
      Bank.Admin.withdraw(1000, "existing_account")
      response = Bank.Admin.check_balance("existing_account")

      assert {:ok, 0} == response
    end

    test "we are able to perform actions on different accounts" do
      Bank.Admin.deposit(100, "existing_account")
      Bank.Admin.withdraw(100, "other_existing_account")

      assert {:ok, 1100} == Bank.Admin.check_balance("existing_account")
      assert {:ok, 900} == Bank.Admin.check_balance("other_existing_account")
    end
  end

end
