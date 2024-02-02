defmodule Checkers.Core do
  def black?(:black), do: true
  def black?(:black_king), do: true
  def black?(_color), do: false

  def white?(:white), do: true
  def white?(:white_king), do: true
  def white?(_color), do: false

  def king?(:black_king), do: true
  def king?(:white_king), do: true
  def king?(_color), do: false

  def man?(:white), do: true
  def man?(:black), do: true
  def man?(_color), do: false

  def promote(:white), do: :white_king
  def promote(:black), do: :black_king

  def switch_turn(:white), do: :black
  def switch_turn(:black), do: :white

  def get_color(:white), do: :white
  def get_color(:white_king), do: :white
  def get_color(:black), do: :black
  def get_color(:black_king), do: :black

  def natural_bindings() do
    %{
      a1: {1, 1}, c1: {3, 1}, e1: {5, 1}, g1: {7, 1},
      b2: {2, 2}, d2: {4, 2}, f2: {6, 2}, h2: {8, 2},
      a3: {1, 3}, c3: {3, 3}, e3: {5, 3}, g3: {7, 3},
      b4: {2, 4}, d4: {4, 4}, f4: {6, 4}, h4: {8, 4},
      a5: {1, 5}, c5: {3, 5}, e5: {5, 5}, g5: {7, 5},
      b6: {2, 6}, d6: {4, 6}, f6: {6, 6}, h6: {8, 6},
      a7: {1, 7}, c7: {3, 7}, e7: {5, 7}, g7: {7, 7},
      b8: {2, 8}, d8: {4, 8}, f8: {6, 8}, h8: {8, 8},
    }
  end
end
