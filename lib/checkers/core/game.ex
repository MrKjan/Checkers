defmodule Checkers.Core.Game do
  alias Checkers.Core.Move
  use Accessible

  defstruct pos: %{},
    player_white: nil,
    player_black: nil,
    moves_valid: [],
    moves_done: [],
    turn: nil

  def new(player1 \\ :a, player2 \\ :b) do
    pos = starting_position()
    turn = :white
    %__MODULE__{
      pos: pos,
      player_white: player1,
      player_black: player2,
      moves_valid: get_valid_moves(pos, turn),
      moves_done: [],
      turn: turn
    }
  end

  defguard is_white(color) when color == :white or color == :white_king
  defguard is_black(color) when color == :black or color == :black_king
  defguard is_empty(color) when color == :empty
  defguard is_king(color) when color == :black_king or color == :white_king
  defguard is_man(color) when color == :white or color == :black

  defguard is_different_colors(color1, color2) when
    (is_white(color1) and is_black(color2)) or (is_black(color1) and is_white(color2))

  def color?(:white, :white), do: true
  def color?(:white_king, :white), do: true
  def color?(:black, :black), do: true
  def color?(:black_king, :black), do: true
  def color?(_color, _expected_color), do: false

  @compile {:inline, switch_turn: 1}
  def switch_turn(:white), do: :black
  def switch_turn(:black), do: :white

  def add_dir(sq, dir, times \\ 1)
  def add_dir({sq_x, sq_y}, _dir, times) when 0 >= times, do: {sq_x, sq_y}
  def add_dir({sq_x, sq_y}, {dir_x, dir_y} = dir, times) do
    add_dir({sq_x + dir_x, sq_y + dir_y}, dir, times - 1)
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

  defp draw_checker({x, y}, pos) do
    cond do
      {x, y} not in Map.keys(pos) -> " "
      pos[{x, y}] == :empty -> "."
      pos[{x, y}] == :white -> "o"
      pos[{x, y}] == :white_king -> "O"
      pos[{x, y}] == :black -> "x"
      pos[{x, y}] == :black_king -> "X"
    end
  end

  def filter_non_nil_values(enum), do: Enum.filter(enum, fn token -> token != nil end)

  def move(game, move) do
    cond do
      move not in game.moves_valid -> game
      true -> game
      |> move_checkers(move)
      |> try_promote(move)
      |> record_move(move)
      |> update_avaliable_turns(move)
      # |> check_win(move)
    end
  end
  def move(game, from, to) when is_atom(from) and is_atom(to) do
    nb = natural_bindings()
    from = nb[from]
    to = nb[to]
    move = Enum.filter(game.moves_valid, fn m -> m.from == from and m.to == to end)
    cond do
      [] == move -> game
      true -> move(game, hd(move))
    end
  end

  def update_avaliable_turns(game, move) when nil != move.capture do
    eaters_moves_valid = get_checker_captures(move.to, game.pos, Move.dir_from_move(move))
    |> filter_non_nil_values
    cond do
      [] == eaters_moves_valid -> update_avaliable_turns(game, nil)
      true -> %{game | moves_valid: eaters_moves_valid}
    end
  end
  def update_avaliable_turns(game, _) do
    %{game | moves_valid: get_valid_moves(game.pos, switch_turn(game.turn)), turn: switch_turn(game.turn)}
  end

  def filter_keys_for_appropriate_color(keys, pos, color) do
    Enum.filter(keys, fn sq -> color?(pos[sq], color) end)
  end

  def get_valid_moves(game), do: get_valid_moves(game.pos, game.turn)
  def get_valid_moves(pos, turn) do
    moves = pos
    |> Map.keys
    |> filter_keys_for_appropriate_color(pos, turn)
    |> Enum.map(fn sq -> get_checker_actions(sq, pos) end)
    |> Enum.concat
    |> filter_non_nil_values
    captures = Enum.filter(
      moves,
      fn move -> nil != move.capture end
    )
    if [] == captures, do: moves, else: captures
  end

  def get_checker_actions(sq, pos, prev_dir \\ nil) do
    captures = get_checker_captures(sq, pos, prev_dir)
    if [] == filter_non_nil_values(captures) do
      get_checker_moves(sq, pos, prev_dir)
    else
      captures
    end
  end

  def get_checker_captures(sq, pos, prev_dir) do
    Enum.map(
      Enum.filter(diagonal_directions(), fn dir -> dir != prev_dir end),
      fn dir -> get_capture_in_direction(dir, pos[sq], sq, pos) end
    )
    |> List.flatten
  end

  def get_capture_in_direction(_dir, color, _sq, _pos) when is_king(color) do
    # TODO: king_capture_in_direction()
    nil
  end
  def get_capture_in_direction(dir, color, sq, pos) when is_man(color) do
    get_man_capture_in_direction(sq, dir, pos)
  end

  def get_man_capture_in_direction(from, dir, pos) do
    from_color = pos[from]
    to = add_dir(from, dir, 2)
    capture = add_dir(from, dir)
    cond do
      not is_empty(pos[to]) -> nil
      not is_different_colors(from_color, pos[capture]) -> nil
      true -> Move.new(capture: capture, color: from_color, from: from, to: to)
    end
  end

  def get_checker_moves(sq, pos, prev_dir) do
    Enum.map(
      Enum.filter(diagonal_directions(), fn dir -> dir != prev_dir end),
      fn dir -> get_move_in_direction(dir, pos[sq], sq, pos) end
    )
    |> List.flatten
  end

  def get_move_in_direction(_dir, color, _sq, _pos) when is_king(color) do
    # TODO: king_move_in_direction()
    nil
  end
  def get_move_in_direction(dir, color, sq, pos) when is_man(color) do
    get_man_move_in_direction(sq, dir, pos)
  end

  def get_man_move_in_direction(sq, dir, pos) do
    to = add_dir(sq, dir)
    cond do
      not is_empty(pos[to]) -> nil
      true -> Move.new(capture: nil, color: pos[sq], from: sq, to: to)
    end
  end

  def move_checkers(game, move) do
    game
    |> remove_from_origin(move)
    |> put_on_destination(move)
    |> try_caprture(move)
  end

  def remove_from_origin(game, move), do: update_in(game, [:pos, move.from], fn _ -> :empty end)
  def put_on_destination(game, move), do: update_in(game, [:pos, move.to], fn _ -> move.color end)

  def try_caprture(game, %Move{capture: nil}), do: game
  def try_caprture(game, %Move{capture: square}), do: update_in(game, [:pos, square], fn _ -> :empty end)

  def try_promote(game, %Move{to: {_x, y}} = move) when :white == move.color and y == 8 do
    update_in(game, [:pos, move.to], fn _ -> :white_king end)
  end
  def try_promote(game, %Move{to: {_x, y}} = move) when :black == move.color and y == 1 do
    update_in(game, [:pos, move.to], fn _ -> :black_king end)
  end
  def try_promote(game, _move), do: game

  def record_move(game, move), do: %{game | moves_done: [move | game.moves_done]}

  def check_win(game) do
    cond do
      # no white
      # no black
      # no moves for current player
      true -> game
    end
  end

  def diagonal_directions(), do: [{1, 1}, {1,-1}, {-1,1}, {-1,-1}]

  @compile {:inline, starting_position: 0}
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
