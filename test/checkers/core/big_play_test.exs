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
    assert is_black(b4.turn)
    assert 12 = Enum.count(b4.pos, fn {_key, val} -> is_white(val) end)
    assert 11 = Enum.count(b4.pos, fn {_key, val} -> is_black(val) end)
  end

  test "double_capture_mamsik_test" do
    b = Board.new :a, :b
    b = Board.natural_move b, :c3 , :b4
    b = Board.natural_move b, :d6 , :c5
    b = Board.natural_move b, :b4 , :a5
    b = Board.natural_move b, :b4 , :d6
    b = Board.natural_move b, :e7 , :c5
    b = Board.natural_move b, :b2 , :c3
    b = Board.natural_move b, :c5 , :b4
    b = Board.natural_move b, :c3 , :a5
    b = Board.natural_move b, :c7 , :d6
    b = Board.natural_move b, :a5 , :c7
    assert b.turn == :white
  end
end
