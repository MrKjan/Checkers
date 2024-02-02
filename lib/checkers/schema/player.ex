defmodule Checkers.Shcema.Player do
  use Ecto.Schema

  schema "player" do
    field :nickname, :string
    field :elo, :integer, default: 500
  end

  def changeset(person, params \\ %{}) do
    person
    |> Ecto.Changeset.cast(params, [:nickname])
    |> Ecto.Changeset.validate_required([:nickname])
  end
end
