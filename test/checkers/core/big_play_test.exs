defmodule BigPlayTest do
  use ExUnit.Case
  alias Checkers.Core.Game
  require Checkers.Core.Game

  test "volobuev_play_start" do
    b = Game.new :a, :b
    assert 7 == Enum.count(Game.get_valid_moves b)
    b1 = Game.move b, %Checkers.Core.Move{capture: nil, color: :white, from: {3, 3}, to: {4, 4}}
    b2 = Game.move b1, :c7, :c5
    b3 = Game.move b2, :f6, :e5
    b4 = Game.move b3, :d4, :f6
    assert Game.is_black(b4.turn)
    assert 12 = Enum.count(b4.pos, fn {_key, val} -> Game.is_white(val) end)
    assert 11 = Enum.count(b4.pos, fn {_key, val} -> Game.is_black(val) end)
  end

  test "double_capture_mamsik_test" do
    b = Game.new :a, :b
    b = Game.move b, :c3 , :b4
    b = Game.move b, :d6 , :c5
    b = Game.move b, :b4 , :a5
    b = Game.move b, :b4 , :d6
    b = Game.move b, :e7 , :c5
    b = Game.move b, :b2 , :c3
    b = Game.move b, :c5 , :b4
    b = Game.move b, :c3 , :a5
    b = Game.move b, :c7 , :d6
    b = Game.move b, :a5 , :c7
    assert b.turn == :white
  end
end
