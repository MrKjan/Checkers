defmodule Checkers.Core.Move do
  defstruct [:capture, :color, :from, :to]

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  @compile {:inline, reaches_end?: 1}
  def reaches_end?(move) when move.color == :white and 8 == elem(move.to, 1), do: true
  def reaches_end?(move) when move.color == :black and 1 == elem(move.to, 1), do: true
  def reaches_end?(_), do: false

  def dir_from_move(move) do
    raw_dir_x = elem(move.to, 0) - elem(move.from, 0)
    raw_dir_y = elem(move.to, 1) - elem(move.from, 1)
    length = abs(raw_dir_x)
    {div(raw_dir_x, length) , div(raw_dir_y, length)}
  end
end
