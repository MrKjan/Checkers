defmodule Checkers.Core.OldBoard do
  alias Checkers.Core.Move
  import Checkers.Core.Utils
  use Accessible

  defstruct pos: %{},
    player_white: nil,
    player_black: nil,
    moves_cnt: 0,
    moves: [],
    turn: :white

  def new(player1, player2) do
    %__MODULE__{
      pos: starting_position(),
      player_white: player1,
      player_black: player2,
      moves_cnt: 0,
      moves: [],
      turn: :white,
    }
  end

  def draw_position(pos) do
    for y <- 8..1 do
      IO.write "#{y} |"
      for x <- 1..8 do
        IO.write "#{draw_checker({x, y}, pos)} "
        # IO.write "#{pos[{x, y}]} "
      end
      IO.write("\n")
    end
    IO.write("   ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\n   A B C D E F G H\n")
  end

  def draw_checker({x, y}, pos) do
    cond do
      {x, y} not in Map.keys(pos) -> " "
      pos[{x, y}] == :empty -> "."
      pos[{x, y}] == :white -> "o"
      pos[{x, y}] == :white_king -> "O"
      pos[{x, y}] == :black -> "x"
      pos[{x, y}] == :black_king -> "X"
    end
  end

  def natural_move(board, from, to) do
    nb = natural_bindings()
    from = nb[from]
    to = nb[to]
    move = Enum.filter(all_possible_moves(board), fn m -> m.from == from and m.to == to end)
    ret = cond do
      nil == from -> board
      nil == to -> board
      [] == move -> board
      board.turn != get_color(board.pos[from]) -> board
      true -> apply_move(hd(move), board)
    end
    # draw_position(ret.pos)
    ret
  end

  defp try_switch_turn(board, move) do
    if not (can_capture?(move.to, board.pos) and nil != move.capture) do
      %{board | turn: switch_turn(board.turn)}
    else
      board
    end
  end

  defp try_promote(board, move) do
    if not is_king(move.color) and Move.reaches_end?(move) do
      update_in(board, [:pos, move.to], fn _ -> promote move.color end)
    else
      board
    end
  end

  @spec apply_move(struct(), __MODULE__) :: __MODULE__ | atom()
  def apply_move(move, board) do
    cond do
      move not in all_possible_moves(board) -> :error
      move.color != board.turn -> :error
      true ->
        board
          |> update_in([:pos, move.from], fn _ -> :empty end)
          |> update_in([:pos, move.to], fn _ -> move.color end)
          |> then(fn b ->
            if nil != move.capture, do: update_in(b, [:pos, move.capture], fn _ -> :empty end), else: b end)
          |> try_promote(move)
          |> try_switch_turn(move)
          |> then(fn b -> %{b | moves_cnt: b.moves_cnt + 1} end)
          |> then(fn b -> %{b | moves: [move | b.moves]} end)
    end
  end

  @spec all_possible_moves(__MODULE__) :: list
  def all_possible_moves(board), do: all_possible_moves(board.pos, board.turn)
  def all_possible_moves(pos, turn) do
    all_right_moves = pos
      |> Map.keys
      |> Enum.map(fn p -> get_possible_right_move(p, pos) end)
    all_moves = pos
      |> Map.keys
      |> Enum.map(fn p -> get_possible_left_move(p, pos) end)
      |> Enum.concat(all_right_moves)
      |> Enum.filter(fn p -> p != nil and p.color == turn end)
    captures = Enum.filter(all_moves, fn p -> nil != p.capture end)
    cond do
      captures != [] -> captures
      true -> all_moves
    end
  end

  def can_capture_right?({x, y}, pos) do
    cond do
      is_white(pos[{x, y}]) and is_black(pos[{x+1, y+1}]) and is_empty(pos[{x+2, y+2}]) -> true
      is_black(pos[{x, y}]) and is_white(pos[{x+1, y-1}]) and is_empty(pos[{x+2, y-2}]) -> true
      true -> false
    end
  end

  def can_capture_left?({x, y}, pos) do
    cond do
      is_white(pos[{x, y}]) and is_black(pos[{x-1, y+1}]) and is_empty(pos[{x-2, y+2}]) -> true
      is_black(pos[{x, y}]) and is_white(pos[{x-1, y-1}]) and is_empty(pos[{x-2, y-2}]) -> true
      true -> false
    end
  end

  def can_move_right?({x, y}, pos) do
    cond do
      is_white(pos[{x, y}]) and is_empty(pos[{x+1, y+1}]) and not can_capture_left?({x, y}, pos) -> true
      is_black(pos[{x, y}]) and is_empty(pos[{x+1, y-1}]) and not can_capture_left?({x, y}, pos) -> true
      true -> false
    end
  end

  def can_move_left?({x, y}, pos) do
    cond do
      is_white(pos[{x, y}]) and is_empty(pos[{x-1, y+1}]) and not can_capture_right?({x, y}, pos) -> true
      is_black(pos[{x, y}]) and is_empty(pos[{x-1, y-1}]) and not can_capture_right?({x, y}, pos) -> true
      true -> false
    end
  end

  def can_move?({x, y}, pos), do: can_move_left?({x, y}, pos) or can_move_right?({x, y}, pos)
  def can_capture?({x, y}, pos), do: can_capture_left?({x, y}, pos) or can_capture_right?({x, y}, pos)

  def get_possible_moves(from, pos), do: [get_possible_right_move(from, pos), get_possible_left_move(from, pos)]

  def get_possible_right_move({x, y}, pos) do
    cond do
      is_white(pos[{x, y}]) and can_move_right?({x, y}, pos) ->
        Move.new(capture: nil, color: :white, from: {x, y}, to: {x+1, y+1})
      is_white(pos[{x, y}]) and can_capture_right?({x, y}, pos) ->
        Move.new(capture: {x+1, y+1}, color: :white, from: {x, y}, to: {x+2, y+2})
      is_black(pos[{x, y}]) and can_move_right?({x, y}, pos) ->
        Move.new(capture: nil, color: :black, from: {x, y}, to: {x+1, y-1})
      is_black(pos[{x, y}]) and can_capture_right?({x, y}, pos) ->
        Move.new(capture: {x+1, y-1}, color: :black, from: {x, y}, to: {x+2, y-2})
      true -> nil
    end
  end

  def get_possible_left_move({x, y}, pos) do
    cond do
      is_white(pos[{x, y}]) and can_move_left?({x, y}, pos) ->
        Move.new(capture: nil, color: :white, from: {x, y}, to: {x-1, y+1})
      is_white(pos[{x, y}]) and can_capture_left?({x, y}, pos) ->
        Move.new(capture: {x-1, y+1}, color: :white, from: {x, y}, to: {x-2, y+2})
      is_black(pos[{x, y}]) and can_move_left?({x, y}, pos) ->
        Move.new(capture: nil, color: :black, from: {x, y}, to: {x-1, y-1})
      is_black(pos[{x, y}]) and can_capture_left?({x, y}, pos) ->
        Move.new(capture: {x-1, y-1}, color: :black, from: {x, y}, to: {x-2, y-2})
      true -> nil
    end
  end

  def starting_position() do
    %{
      {1, 1} => :white, {3, 1} => :white, {5, 1} => :white, {7, 1} => :white,
      {2, 2} => :white, {4, 2} => :white, {6, 2} => :white, {8, 2} => :white,
      {1, 3} => :white, {3, 3} => :white, {5, 3} => :white, {7, 3} => :white,
      {2, 4} => :empty, {4, 4} => :empty, {6, 4} => :empty, {8, 4} => :empty,
      {1, 5} => :empty, {3, 5} => :empty, {5, 5} => :empty, {7, 5} => :empty,
      {2, 6} => :black, {4, 6} => :black, {6, 6} => :black, {8, 6} => :black,
      {1, 7} => :black, {3, 7} => :black, {5, 7} => :black, {7, 7} => :black,
      {2, 8} => :black, {4, 8} => :black, {6, 8} => :black, {8, 8} => :black,
    }
  end
end
