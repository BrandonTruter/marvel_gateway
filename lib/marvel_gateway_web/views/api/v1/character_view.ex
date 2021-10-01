defmodule MarvelGatewayWeb.Api.V1.CharacterView do
  use MarvelGatewayWeb, :view
  alias MarvelGatewayWeb.Api.V1.CharacterView

  def render("index.json", %{characters: characters}) do
    %{data: render_many(characters, CharacterView, "character.json")}
  end

  def render("show.json", %{character: character}) do
    %{data: render_one(character, CharacterView, "character.json")}
  end

  def render("character.json", %{character: character}) do
    %{
      id: character.id,
      name: character.name,
      description: character.description,
      attribution_text: character.attribution_text,
      hero_id: character.hero_id,
      etag: character.etag,
      image_format: character.image_format,
      image_location: character.image_location
    }
  end
end
