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

  def create_changeset(person, params \\ %{}) do
    params_changeset(person, params)
    |> changeset(params)
  end

  def params_changeset(person, params \\ %{}) do
    types = %{username: :string}

    {person, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_length(:username, min: 3, message: "Username is not valid")
  end
end
