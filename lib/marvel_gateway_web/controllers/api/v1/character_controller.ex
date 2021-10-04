defmodule MarvelGatewayWeb.Api.V1.CharacterController do
  use MarvelGatewayWeb, :controller
  alias MarvelGateway.{
    Heroes, Heroes.Character
  }
  alias MarvelGateway.Marvel
  action_fallback MarvelGatewayWeb.Api.FallbackController

  def index(conn, _params) do
    characters =
      case Heroes.list_characters() do
        heroes when heroes in [nil, %{}, []] ->
          Marvel.list_characters
            |> parse_response
        heroes -> heroes
      end
    render(conn, "index.json", characters: characters)
  end

  def show(conn, %{"id" => id}) do
    character =
      case Heroes.get_character(id) do
        nil ->
          Marvel.find_character(id)
            |> parse_response(:show)
            |> Heroes.create_character
            |> case do
              {:ok, character} -> character
              {:error, _} -> nil
            end
        character -> character
      end
    render(conn, "show.json", character: character)
  end

  def parse_response(response) do
    response |> Marvel.parse_characters
  end

  def parse_response(response, :show) do
    response |> Marvel.parse_character
  end

  def delete(conn, %{"id" => id}) do
    character = Heroes.get_character(id)

    with {:ok, %Character{}} <- Heroes.delete_character(character) do
      send_resp(conn, :no_content, "")
    end
  end
end
