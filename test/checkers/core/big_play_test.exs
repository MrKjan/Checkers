defmodule BigPlayTest do
  use ExUnit.Case
  alias Checkers.Core.OldBoard
  import Checkers.Core.Utils

  test "volobuev_play_start" do
    b = OldBoard.new :a, :b
    assert 7 == Enum.count(OldBoard.all_possible_moves b)
    b1 = OldBoard.apply_move %Checkers.Core.Move{capture: nil, color: :white, from: {3, 3}, to: {4, 4}}, b
    b2 = OldBoard.natural_move b1, :c7, :c5
    b3 = OldBoard.natural_move b2, :f6, :e5
    b4 = OldBoard.natural_move b3, :d4, :f6
    assert is_black(b4.turn)
    assert 12 = Enum.count(b4.pos, fn {_key, val} -> is_white(val) end)
    assert 11 = Enum.count(b4.pos, fn {_key, val} -> is_black(val) end)
  end

  test "double_capture_mamsik_test" do
    b = OldBoard.new :a, :b
    b = OldBoard.natural_move b, :c3 , :b4
    b = OldBoard.natural_move b, :d6 , :c5
    b = OldBoard.natural_move b, :b4 , :a5
    b = OldBoard.natural_move b, :b4 , :d6
    b = OldBoard.natural_move b, :e7 , :c5
    b = OldBoard.natural_move b, :b2 , :c3
    b = OldBoard.natural_move b, :c5 , :b4
    b = OldBoard.natural_move b, :c3 , :a5
    b = OldBoard.natural_move b, :c7 , :d6
    b = OldBoard.natural_move b, :a5 , :c7
    assert b.turn == :white
  end
end
