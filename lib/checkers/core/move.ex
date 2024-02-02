defmodule Checkers.Core.Move do
  defstruct [:capture, :color, :from, :to]

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def reaches_end?(move) do
    cond do
      move.color == :white and elem(move.to, 1) == 8 -> true
      move.color == :black and elem(move.to, 1) == 1 -> true
      true -> false
    end
  end
end
