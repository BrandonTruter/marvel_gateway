defmodule MarvelGateway.Heroes.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do
    field :description, :string
    field :name, :string
    field :etag, :string
    field :hero_id, :integer
    field :image_format, :string
    field :image_location, :string
    field :attribution_text, :string

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :description, :etag, :hero_id, :image_location, :image_format, :attribution_text])
    |> validate_required([:name, :hero_id, :attribution_text])
  end
end
