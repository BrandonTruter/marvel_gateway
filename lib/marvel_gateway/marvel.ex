defmodule MarvelGateway.Marvel do
  require Logger
  @configs Application.get_env(:marvel_gateway, :developer_portal)

  def list_characters() do
    marvel_api_request()
  end

  def find_character(id) do
    marvel_api_request("characters", :get, id)
  end

  def marvel_api_request(endpoint \\ "characters", method \\ :get, params \\ "") do
    try do
      ts = timestamp()
      url = build_url(endpoint, params)
      query_string = build_query_string(ts)

      case ApiRequest.request("#{url}?#{query_string}", method, headers(), "") do
        {200, response} ->
          {:ok, response}

        {st, error_message} ->
          Logger.error("ERROOR: status: #{st}, message: #{inspect(error_message)}")
          {:error, error_message}
      end
    rescue e ->
      Logger.error("EXCEPTION: #{inspect(e)}")
      {:error, inspect(e)}
    end
  end

  defp build_url(endpoint, params) do
    case params do
      "" -> "#{base_url()}/#{endpoint}"

      character_id ->
        base_url() <> "/#{endpoint}" <> "/#{character_id}"
    end
  end

  def build_query_string(ts) do
    credentials(ts, fetch_keys("private_key"), fetch_keys("public_key")) |> URI.encode_query
  end

  defp timestamp(), do: DateTime.utc_now |> DateTime.to_string

  def credentials(ts, pvt_key, pub_key) do
    %{
      ts: ts,
      apikey: pub_key,
      hash: hash(ts, pvt_key, pub_key)
    }
  end

  defp hash(ts, pvt_key, pub_key) do
    :crypto.hash(:md5, "#{ts}#{pvt_key}#{pub_key}")
      |> Base.encode16(case: :lower, padding: false)
  end

  defp fetch_keys(type) do
    case System.get_env(String.upcase(type)) do
      nil -> @configs[String.to_atom(type)]
      val -> val
    end
  end

  defp base_url() do
    System.get_env("BASE_URL") || @configs[:base_url]
  end

  defp headers() do
    [{"Content-type", "application/json; charset=utf-8"}]
  end

  def parse_characters(response) do
    case response do
      {:ok, characters} ->
        characters["data"]["results"]
          |> Enum.with_index()
          |> Enum.map(fn {character, index} ->
            %{
              etag: "",
              hero_id: index,
              id: character["id"],
              name: character["name"],
              description: character["description"],
              attribution_text: characters["attributionText"],
              image_format: character["thumbnail"]["extension"],
              image_location: character["thumbnail"]["path"]
            }
          end)
      {:error, errors} -> nil
    end
  end

  def parse_character(response) do
    case response do
      {:ok, response} ->
        valid_response? = if response["code"] == 200, do: true, else: false

        if valid_response? do
          character = response["data"]["results"] |> List.first
          %{
            etag: response["etag"],
            hero_id: character["id"],
            name: character["name"],
            description: character["description"],
            attribution_text: response["attributionText"],
            image_format: character["thumbnail"]["extension"],
            image_location: character["thumbnail"]["path"]
          }
        end
      {:error, errors} -> nil
    end
  end

end
