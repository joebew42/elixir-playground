defmodule EctoExamples.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      EctoExamples.Repo
    ]

    opts = [strategy: :one_for_one, name: EctoExamples.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
