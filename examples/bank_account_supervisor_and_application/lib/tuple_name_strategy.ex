defmodule TupleNameStrategy do
  def create(name) do
    {:via, Bank.AccountRegistry, name}
  end
end
