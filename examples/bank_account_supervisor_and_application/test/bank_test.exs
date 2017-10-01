defmodule BankTest do
  use ExUnit.Case

  describe "when account does not exists" do

    setup do
      start_supervised({BankAccountSupervisor, name: BankAccountSupervisor})
      start_supervised BankAccountRegistry
      {:ok, bank_pid} = start_supervised BankServer
      %{bank_pid: bank_pid}
    end

    test "we are able to create a new account", %{bank_pid: bank_pid} do
      response = Bank.create_account(bank_pid, "an_account")

      assert {:ok, :account_created} == response
    end

    test "we are not able to delete an account", %{bank_pid: bank_pid} do
      response = Bank.delete_account(bank_pid, "non_existing_account")

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to check current balance", %{bank_pid: bank_pid} do
      response = Bank.check_balance(bank_pid, "non_existing_account")

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to deposit", %{bank_pid: bank_pid} do
      response = Bank.deposit(bank_pid, 1, "non_existing_account")

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to withdraw", %{bank_pid: bank_pid} do
      response = Bank.withdraw(bank_pid, 1, "non_existing_account")

      assert {:error, :account_not_exists} == response
    end
  end

  describe "when account exists" do

    setup do
      start_supervised({BankAccountSupervisor, name: BankAccountSupervisor})
      start_supervised BankAccountRegistry
      {:ok, bank_pid} = start_supervised BankServer
      Bank.create_account(bank_pid, "existing_account")
      Bank.create_account(bank_pid, "other_existing_account")

      %{bank_pid: bank_pid}
    end

    test "we are not able to create an account with the same name", %{bank_pid: bank_pid} do
      response = Bank.create_account(bank_pid, "existing_account")

      assert {:error, :account_already_exists} == response
    end

    test "we are able to delete an account", %{bank_pid: bank_pid} do
      response_account_deleted = Bank.delete_account(bank_pid, "existing_account")
      response_account_not_exists = Bank.delete_account(bank_pid, "existing_account")

      assert {:ok, :account_deleted} == response_account_deleted
      assert {:error, :account_not_exists} == response_account_not_exists
    end

    test "we are able to check the current balance", %{bank_pid: bank_pid} do
      response = Bank.check_balance(bank_pid, "existing_account")

      assert {:ok, 1000} == response
    end

    test "we are able to deposit positive amounts", %{bank_pid: bank_pid} do
      Bank.deposit(bank_pid, 50, "existing_account")
      Bank.deposit(bank_pid, 100, "existing_account")
      Bank.deposit(bank_pid, 200, "existing_account")
      response = Bank.check_balance(bank_pid, "existing_account")

      assert {:ok, 1000 + 50 + 100 + 200} == response
    end

    test "we are not able to deposit negative amounts", %{bank_pid: bank_pid} do
      Bank.deposit(bank_pid, -100, "existing_account")
      response = Bank.check_balance(bank_pid, "existing_account")

      assert {:ok, 1000} == response
    end

    test "we are not able to withdraw if the amount is greater than current balance", %{bank_pid: bank_pid} do
      response = Bank.withdraw(bank_pid, 1001, "existing_account")

      assert {:error, :withdrawal_not_permitted} == response
    end

    test "we are not able to withdraw a negative amount", %{bank_pid: bank_pid} do
      response = Bank.withdraw(bank_pid, -1, "existing_account")

      assert {:error, :withdrawal_not_permitted} == response
    end

    test "we are able to withdraw if the amount is lower or equal than current balance", %{bank_pid: bank_pid} do
      Bank.withdraw(bank_pid, 1000, "existing_account")
      response = Bank.check_balance(bank_pid, "existing_account")

      assert {:ok, 0} == response
    end

    test "we are able to perform actions on different accounts", %{bank_pid: bank_pid} do
      Bank.deposit(bank_pid, 100, "existing_account")
      Bank.withdraw(bank_pid, 100, "other_existing_account")

      assert {:ok, 1100} == Bank.check_balance(bank_pid, "existing_account")
      assert {:ok, 900} == Bank.check_balance(bank_pid, "other_existing_account")
    end
  end

end
