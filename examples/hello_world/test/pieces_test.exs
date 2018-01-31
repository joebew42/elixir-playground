defmodule PiecesTest do
  use ExUnit.Case

  test "xxx" do
    result = Pieces.fooo2(["a","b","c","d"])

    assert result == ["a,","b,","c,","d"]
  end
end
