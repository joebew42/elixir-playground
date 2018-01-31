use Mix.Config

config :ecto_examples, EctoExamples.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_examples",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
