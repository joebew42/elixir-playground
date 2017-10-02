defmodule TupleName do
  def create(name) do
    {:via, BankAccountRegistry, name}
  end
end
