defmodule EctoExamples.Repo.Migrations.PostBelongsToPerson do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :person_id, references(:people)
    end
  end
end
