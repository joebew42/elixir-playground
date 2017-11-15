defmodule EctoExamples.Person do
  use Ecto.Schema

  schema "people" do
    field :first_name, :string
    field :last_name, :string
    field :age, :integer
    has_many :posts, EctoExamples.Post
  end

  def changeset(person, params \\ %{}) do
    person
    |> Ecto.Changeset.cast(params, [:first_name, :last_name, :age])
    |> Ecto.Changeset.validate_required([:first_name, :last_name])
    |> Ecto.Changeset.no_assoc_constraint(:posts)
  end
end
