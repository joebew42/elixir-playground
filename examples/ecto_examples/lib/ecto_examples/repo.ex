defmodule EctoExamples.Repo do
  use Ecto.Repo,
  otp_app: :ecto_examples,
  adapter: Ecto.Adapters.Postgres
end
