use Mix.Config

config :ecto_examples, EctoExamples.Repo,
  adapter: Sqlite.Ecto2,
  database: "ecto_examples.sqlite3"

config :ecto_examples, ecto_repos: [EctoExamples.Repo]
