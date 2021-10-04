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
            |> Marvel.parse_character
            |> Heroes.create_character
            |> case do
              {:ok, character} -> character
              {:error, _} -> nil
            end
        character -> character
      end
    render(conn, "show.json", character: character)
  end

  # def process_character_response(response) do
  #   response
  #   |> parse_response(:show)
  #   |> case do
  #     character_response -> if not is_nil(character_response) do
  #       case Heroes.create_character(character_response) do
  #         {:ok, character} -> character
  #         {:error, _} -> character_response
  #       end
  #     end
  #   end
  # end

  # def render_error_response(message) do
  #
  # end

  # def parse_response(response, action) do
  #   case action do
  #     nil -> Marvel.parse_characters(response)
  #     :show -> Marvel.parse_character(response)
  #   end
  # end

  def parse_response(response) do
    response |> Marvel.parse_characters
  end

  def parse_response(response, action) do
    case action do
      nil -> Marvel.parse_characters(response)
      :show -> Marvel.parse_character(response)
    end
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
