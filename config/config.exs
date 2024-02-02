import Config

config :checkers,
  ecto_repos: [Checkers.Repo]

config :checkers, Checkers.Repo,
  database: "db/checkers_repo",
  username: "",
  password: "",
  hostname: "localhost"
