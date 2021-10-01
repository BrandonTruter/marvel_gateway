defmodule MarvelGatewayWeb.Api.V1.CharacterController do
  use MarvelGatewayWeb, :controller
  alias MarvelGateway.{Heroes, Heroes.Character}
  action_fallback MarvelGatewayWeb.Api.FallbackController

  def index(conn, _params) do
    characters = Heroes.list_characters()
    render(conn, "index.json", characters: characters)
  end

  def show(conn, %{"id" => id}) do
    character = Heroes.get_character!(id)
    render(conn, "show.json", character: character)
  end

  def create(conn, %{"character" => character_params}) do
    with {:ok, %Character{} = character} <- Heroes.create_character(character_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.character_path(conn, :show, character))
      |> render("show.json", character: character)
    end
  end

  def delete(conn, %{"id" => id}) do
    character = Heroes.get_character!(id)

    with {:ok, %Character{}} <- Heroes.delete_character(character) do
      send_resp(conn, :no_content, "")
    end
  end
end
