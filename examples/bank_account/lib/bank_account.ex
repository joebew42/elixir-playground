defmodule BankAccount do
  def start() do
    spawn(fn -> BankAccountServer.loop(1000) end)
  end

  def stop(pid) do
    Process.exit(pid, :kill)
  end

  def check_balance(bank_account) do
    execute(bank_account, {:check_balance})
  end

  def deposit(bank_account, amount) do
    execute(bank_account, {:deposit, amount})
  end

  def withdraw(bank_account, amount) do
    execute(bank_account, {:withdraw, amount})
  end

  defp execute(pid, message) do
    send pid, {self(), message}
    receive do
      reply -> reply
    end
  end
end
