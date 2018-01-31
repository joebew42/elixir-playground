defmodule Pieces do
  def fooo(pieces) do
    [last | rest] = Enum.reverse(pieces)
    rest = Enum.map(rest, fn p -> (p <> ",") end)
    Enum.reverse([last | rest])
  end

  def fooo2(pieces, result \\ [])
  def fooo2(last = [_], result), do: result ++ last
  def fooo2([head | tail], result), do: fooo2(tail, result ++ [head <> ","])
end
