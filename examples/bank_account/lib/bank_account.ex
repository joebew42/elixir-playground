defmodule BankAccount do
  def start() do
    spawn(fn -> BankAccountServer.loop(1000) end)
  end

  def stop(bank_account_pid) do
    Process.exit(bank_account_pid, :kill)
  end

  def check_balance(bank_account_pid) do
    execute(bank_account_pid, {:check_balance})
  end

  def deposit(bank_account_pid, amount) do
    execute(bank_account_pid, {:deposit, amount})
  end

  def withdraw(bank_account_pid, amount) do
    execute(bank_account_pid, {:withdraw, amount})
  end

  defp execute(bank_account_pid, message) do
    send bank_account_pid, {self(), message}
    receive do
      reply -> reply
    end
  end
end
