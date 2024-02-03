defmodule Checkers.Core.Move do
  defstruct [:capture, :color, :from, :to]

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  @compile {:inline, reaches_end?: 1}
  def reaches_end?(move) when move.color == :white and 8 == elem(move.to, 1), do: true
  def reaches_end?(move) when move.color == :black and 1 == elem(move.to, 1), do: true
  def reaches_end?(_), do: false
end
