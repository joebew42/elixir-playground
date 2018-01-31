defmodule EctoExamples.Person do
  use Ecto.Schema

  @allowed_params [:first_name, :last_name, :age]
  @required_params [:first_name, :last_name]

  schema "people" do
    field :first_name, :string
    field :last_name, :string
    field :age, :integer
    has_many :posts, EctoExamples.Post
  end

  def changeset(person, params \\ %{}) do
    person
    |> Ecto.Changeset.cast(params, @allowed_params)
    |> Ecto.Changeset.validate_required(@required_params)
    |> Ecto.Changeset.no_assoc_constraint(:posts)
  end
end
