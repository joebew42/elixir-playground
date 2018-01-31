use Mix.Config

config :ecto_examples, ecto_repos: [EctoExamples.Repo]

import_config "#{Mix.env}.exs"
