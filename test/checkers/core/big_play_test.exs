defmodule BigPlayTest do
  use ExUnit.Case
  alias Checkers.Core.Board
  import Checkers.Core.Utils

  test "volobuev_play_start" do
    b = Board.new :a, :b
    assert 7 == Enum.count(Board.all_possible_moves b)
    b1 = Board.apply_move %Checkers.Core.Move{capture: nil, color: :white, from: {3, 3}, to: {4, 4}}, b
    b2 = Board.natural_move b1, :c7, :c5
    b3 = Board.natural_move b2, :f6, :e5
    b4 = Board.natural_move b3, :d4, :f6
    assert black?(b4.turn)
    assert 12 = Enum.count(b4.pos, fn {key, val} -> white?(val) end)
    assert 11 = Enum.count(b4.pos, fn {key, val} -> black?(val) end)
  end
end
