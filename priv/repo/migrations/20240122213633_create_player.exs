defmodule Checkers.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:player) do
      add :nickname, :string
      add :elo, :integer
    end
  end
end
