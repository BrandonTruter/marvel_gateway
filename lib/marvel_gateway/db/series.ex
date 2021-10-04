defmodule MarvelGateway.Heroes.Series do
  use Ecto.Schema
  import Ecto.Changeset

  schema "series" do
    field :description, :string
    field :etag, :string
    field :story_count, :integer
    field :thumbnail, :map
    field :title, :string
    # field :character_id, :id
    belongs_to(:character, MarvelGateway.Heroes.Character, foreign_key: :character_id)

    timestamps()
  end

  @doc false
  def changeset(series, attrs) do
    series
    |> cast(attrs, [:title, :description, :etag, :thumbnail, :story_count])
    |> validate_required([:title])
    |> foreign_key_constraint(:character_id)
    |> cast_assoc(:character)
  end
end
