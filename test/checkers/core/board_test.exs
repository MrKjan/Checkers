defmodule BoardTest do
  use ExUnit.Case
  doctest Checkers.Core.Board

  test "white move right" do
    assert Checkers.Core.Board.get_possible_right_move({1, 1}, %{{1, 1} => :white, {2, 2} => :empty}) ==
      %Checkers.Core.Move{type: :move, color: :white, from: {1, 1}, to: {2, 2}}
  end
  test "white eat right" do
    assert Checkers.Core.Board.get_possible_right_move(
      {1, 1}, %{{1, 1} => :white, {2, 2} => :black, {3, 3} => :empty}
    ) == %Checkers.Core.Move{type: :capture, color: :white, from: {1, 1}, to: {3, 3}}
  end
  test "white cant move right cause of board" do
    assert Checkers.Core.Board.get_possible_right_move({1, 1}, %{{1, 1} => :white,}) == nil
  end
  test "white cant move right cause of enemy" do
    assert Checkers.Core.Board.get_possible_right_move({1, 1}, %{{1, 1} => :white, {2, 2} => :black,}) == nil
  end
  test "white cant move right cause of 2 enemies" do
    assert Checkers.Core.Board.get_possible_right_move(
      {1, 1}, %{{1, 1} => :white, {2, 2} => :black, {3, 3} => :black}
    ) == nil
  end
  test "white cant move right cause of left capture" do
    assert Checkers.Core.Board.get_possible_right_move(
      {3, 1},
      %{{3, 1} => :white, {2, 2} => :black, {1, 3} => :empty, {4, 2} => :empty}
    ) == nil
  end
  test "get all two moves" do
    assert Checkers.Core.Board.all_possible_moves(
      %{{3, 1} => :white, {2, 2} => :empty, {4, 2} => :empty},
      :white
    ) == [
      %Checkers.Core.Move{type: :move, color: :white, from: {3, 1}, to: {2, 2}},
      %Checkers.Core.Move{type: :move, color: :white, from: {3, 1}, to: {4, 2}}
    ]
  end
  test "get all two captures" do
    assert Checkers.Core.Board.all_possible_moves(
      %{{3, 1} => :white, {2, 2} => :black, {4, 2} => :black, {1, 3} => :empty, {5, 3} => :empty},
      :white
    ) == [
      %Checkers.Core.Move{type: :capture, color: :white, from: {3, 1}, to: {1, 3}},
      %Checkers.Core.Move{type: :capture, color: :white, from: {3, 1}, to: {5, 3}}
    ]
  end
  test "get only expected color" do
    assert Checkers.Core.Board.all_possible_moves(
      %{{3, 1} => :white, {2, 2} => :empty, {1, 3} => :black},
      :black
    ) == [
      %Checkers.Core.Move{type: :move, color: :black, from: {1, 3}, to: {2, 2}},
    ]
  end
end
