defmodule EctoExamplesTest do
  use ExUnit.Case

  alias EctoExamples.Person

  @valid_person  %Person{first_name: "joe", last_name: "bew"}

  setup_all do
    EctoExamples.Application.start(nil, nil)
    :timer.sleep(50)
    :ok
  end

  test "validation should fail" do
    %Ecto.Changeset{errors: errors} = %Person{}
    |> Person.changeset

    assert [] != errors
  end

  test "validation should be valid" do
    %Ecto.Changeset{errors: errors} = @valid_person
    |> Person.changeset

    assert [] == errors
  end

  test "should insert a person" do
    {result, _} = @valid_person
    |> Person.changeset(%{})
    |> EctoExamples.Repo.insert

    assert :ok == result
  end

  test "should fail if there are associated posts" do
    {_, person} = @valid_person
    |> Person.changeset(%{})
    |> EctoExamples.Repo.insert

    first_post = Ecto.build_assoc(person, :posts, %{header: "Clickbait header", body: "No real content"})
    first_post |> EctoExamples.Repo.insert

    second_post = Ecto.build_assoc(person, :posts, %{header: "Second post title", body: "No real content"})
    second_post |> EctoExamples.Repo.insert

    person_with_posts = EctoExamples.Person
    |> EctoExamples.Repo.get(person.id)
    |> EctoExamples.Repo.preload(:posts)

    assert person_with_posts.posts != []

    {result, _} = person_with_posts
    |> EctoExamples.Person.changeset(%{})
    |> EctoExamples.Repo.delete

    assert :error == result
  end

end
