defmodule MarvelGateway.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string
      add :description, :text
      add :etag, :string
      add :hero_id, :integer
      add :image_location, :string
      add :image_format, :string
      add :attribution_text, :string

      timestamps()
    end
  end
end
