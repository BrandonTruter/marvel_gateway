defmodule MarvelGatewayWeb.Api.V1.SeriesController do
  use MarvelGatewayWeb, :controller
  alias MarvelGateway.{
    Marvel,
    Heroes,
    Heroes.Series,
    Heroes.Character
  }

  def show(conn, %{"id" => id}) do
    series =
      case Heroes.get_series(id) do
        marvel_series when marvel_series in [nil, %{}, []] ->
          Marvel.find_series(id)
            |> Marvel.parse_series
            |> Enum.map(fn s ->
              s.character_id
                |> Heroes.get_series_with_title(s.title)
                |> case do
                  nil ->
                    case Heroes.create_series(s) do
                      {:ok, cached_series} -> cached_series
                      {:error, _error_message} -> nil
                    end
                  cached_series -> cached_series
                end
            end)
        marvel_series -> marvel_series
      end
    render(conn, "show.json", series: series)
  end

  def delete(conn, %{"id" => id}) do
    series = Heroes.get_series(id)

    with {:ok, %Series{}} <- Heroes.delete_series(series) do
      send_resp(conn, :no_content, "")
    end
  end
end
