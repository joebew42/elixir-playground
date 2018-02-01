defmodule EctoExamplesTest do
  use ExUnit.Case, async: true

  alias EctoExamples.{Person, Repo}

  @valid_person  %Person{first_name: "joe", last_name: "bew"}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "validation should fail" do
    changeset = Person.changeset(%Person{})

    refute changeset.valid?
  end

  test "validation should be valid" do
    changeset = Person.changeset(@valid_person)

    assert changeset.valid?
  end

  test "validation should fail when parameter is not valid" do
    changeset = Person.params_changeset(@valid_person, %{username: "jo"})

    {message, _} = changeset.errors[:username]

    assert message == "Username is not valid"
  end

  test "should insert a person" do
    {result, _} = @valid_person
    |> Person.changeset(%{})
    |> Repo.insert

    assert :ok == result
  end

  test "should fail if there are associated posts" do
    {_, person} = @valid_person
    |> Person.changeset(%{})
    |> Repo.insert

    first_post = Ecto.build_assoc(person, :posts, %{header: "Clickbait header", body: "No real content"})
    first_post |> Repo.insert

    second_post = Ecto.build_assoc(person, :posts, %{header: "Second post title", body: "No real content"})
    second_post |> Repo.insert

    person_with_posts = Person
    |> Repo.get(person.id)
    |> Repo.preload(:posts)

    assert person_with_posts.posts != []

    {result, _} = person_with_posts
    |> Person.changeset(%{})
    |> Repo.delete

    assert :error == result
  end

end
