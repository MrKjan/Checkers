defmodule Checkers.Core.Utils do
  defguard is_white(color) when color == :white or color == :white_king
  defguard is_black(color) when color == :black or color == :black_king
  defguard is_empty(color) when color == :empty
  defguard is_king(color) when color == :black_king or color == :white_king
  defguard is_man(color) when color == :white or color == :black

  @compile {:inline, promote: 1}
  def promote(:white), do: :white_king
  def promote(:black), do: :black_king

  @compile {:inline, switch_turn: 1}
  def switch_turn(:white), do: :black
  def switch_turn(:black), do: :white

  @compile {:inline, get_color: 1}
  def get_color(:white), do: :white
  def get_color(:white_king), do: :white
  def get_color(:black), do: :black
  def get_color(:black_king), do: :black

  @compile {:inline, natural_bindings: 0}
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
