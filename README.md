# Checkers

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `checkers` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:checkers, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/checkers>.

# Commands
iex.bat -S mix
    recompile
mix new checkers --sup
mix deps.get
mix ecto.gen.repo -r Checkers.Repo
mix ecto.create
mix ecto.gen.migration create_player
mix ecto.migrate
mix ecto.drop

