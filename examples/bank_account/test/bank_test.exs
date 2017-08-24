defmodule BankTest do
  use ExUnit.Case

  describe "when account does not exists" do

    setup do
      bank_pid = Bank.start()
      %{bank_pid: bank_pid}
    end

    test "we are able to create a new account", %{bank_pid: bank_pid} do
      created_response = Bank.execute(bank_pid, {:create_account, "non_existing_account"})
      already_exists_response = Bank.execute(bank_pid, {:create_account, "non_existing_account"})

      assert {:ok, :account_created} == created_response
      assert {:error, :account_already_exists} == already_exists_response
    end

    test "we are not able to check current balance", %{bank_pid: bank_pid} do
      response = Bank.execute(bank_pid, {:current_balance_of, "non_existing_account"})

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to deposit", %{bank_pid: bank_pid} do
      response = Bank.execute(bank_pid, {:deposit, 1, "non_existing_account"})

      assert {:error, :account_not_exists} == response
    end

    test "we are not able to withdrawal", %{bank_pid: bank_pid} do
      response = Bank.execute(bank_pid, {:withdrawal, 1, "non_existing_account"})

      assert {:error, :account_not_exists} == response
    end
  end

  describe "when account exists" do

    setup do
      bank_pid = Bank.start()
      Bank.execute(bank_pid, {:create_account, "existing_account"})

      %{bank_pid: bank_pid}
    end

    test "we are not able to create an account with the same name", %{bank_pid: bank_pid} do
      response = Bank.execute(bank_pid, {:create_account, "existing_account"})

      assert {:error, :account_already_exists} == response
    end

    test "we are able to check the current balance", %{bank_pid: bank_pid} do
      response = Bank.execute(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1000} == response
    end

    test "we are able to deposit positive amounts", %{bank_pid: bank_pid} do
      Bank.execute(bank_pid, {:deposit, 50, "existing_account"})
      Bank.execute(bank_pid, {:deposit, 100, "existing_account"})
      Bank.execute(bank_pid, {:deposit, 200, "existing_account"})
      response = Bank.execute(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1000 + 50 + 100 + 200} == response
    end

    test "we are not able to deposit negative amounts", %{bank_pid: bank_pid} do
      Bank.execute(bank_pid, {:deposit, -100, "existing_account"})
      response = Bank.execute(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 1000} == response
    end

    test "we are not able to withdrawal if the amount is greater than current balance", %{bank_pid: bank_pid} do
      response = Bank.execute(bank_pid, {:withdrawal, 1001, "existing_account"})

      assert {:error, :withdrawal_not_permitted} == response
    end

    test "we are not able to withdrawal a negative amount", %{bank_pid: bank_pid} do
      response = Bank.execute(bank_pid, {:withdrawal, -1, "existing_account"})

      assert {:error, :withdrawal_not_permitted} == response
    end

    test "we are able to withdrawal if the amount is lower or equal than current balance", %{bank_pid: bank_pid} do
      Bank.execute(bank_pid, {:withdrawal, 1000, "existing_account"})
      response = Bank.execute(bank_pid, {:current_balance_of, "existing_account"})

      assert {:ok, 0} == response
    end
  end

  test "returns error when a message cannot be handled" do
    bank_pid = Bank.start()
    response = Bank.execute(bank_pid, {:message_that_cannot_be_handled})

    assert {:error, :not_handled} = response
  end

end
