defmodule Checkers.Repo do
  use Ecto.Repo,
    otp_app: :checkers,
    adapter: Ecto.Adapters.SQLite3

    def add_player(nickname) do
      Checkers.Shcema.Player.changeset(%Checkers.Shcema.Player{nickname: nickname})
      |> Checkers.Repo.insert()
    end

    def add_test_players() do
      players = [
        %Checkers.Shcema.Player{nickname: "Josh", elo: 600},
        %Checkers.Shcema.Player{nickname: "Steve"},
        %Checkers.Shcema.Player{nickname: "Ludo", elo: 400},
        %Checkers.Shcema.Player{nickname: "Laszlo"},
        %Checkers.Shcema.Player{nickname: "Gugo"},
      ]
      Enum.each(players, fn player -> Checkers.Repo.insert(player) end)
    end

    def show_first_player, do: Checkers.Shcema.Player |> Ecto.Query.first |> Checkers.Repo.one
    def show_playes do
      # q = Ecto.Query.from p in Checkers.Shcema.Player, order_by: [asc: p.id]
      # Checkers.Repo.get q
      Checkers.Shcema.Player |> Checkers.Repo.all
    end
end
