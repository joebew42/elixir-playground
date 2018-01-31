use Mix.Config

config :logger, level: :info

config :ecto_examples, EctoExamples.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_examples",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432",
  pool: Ecto.Adapters.SQL.Sandbox
