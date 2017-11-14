defmodule EctoExamples.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ecto_examples,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :sqlite_ecto2, :ecto]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.0"},
      {:sqlite_ecto2, "~> 2.2"}
    ]
  end
end
