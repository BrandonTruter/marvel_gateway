defmodule MarvelGateway.Repo.Migrations.CreateSeries do
  use Ecto.Migration

  def change do
    create table(:series) do
      add :title, :string
      add :description, :text
      add :etag, :string
      add :thumbnail, :map
      add :story_count, :integer
      add :character_id, references(:characters, on_delete: :nothing)

      timestamps()
    end
  end
end
