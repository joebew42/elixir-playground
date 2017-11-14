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

end
