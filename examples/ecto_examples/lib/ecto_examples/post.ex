defmodule EctoExamples.Post do
  use Ecto.Schema

  schema "posts" do
    field :header, :string
    field :body, :string
    belongs_to :person, EctoExamples.Person
  end
end
