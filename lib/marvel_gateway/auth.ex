defmodule MarvelGateway.Auth do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    configs = fetch_configs
    api_key = fetch_key(conn)
    pub_key = configs[:public_key]
    valid_key? = api_key == pub_key

    if valid_key? do
      conn
    else
      conn
      |> put_status(401)
      |> json(%{error: "Access denied, invalid credentials"})
      |> halt()
    end
  end

  defp fetch_key(conn) do
    key =
      conn
      |> get_req_header("apikey")
      |> List.first()

    is_nil?(conn, key)
  end

  defp is_nil?(conn, val) do
    case val do
      nil ->
        conn
        |> put_status(401)
        |> json(%{error: "Access denied, API Key is required"})
        |> halt()
      val ->
        val
    end
  end

  defp fetch_configs do
    Application.get_env(:marvel_gateway, :developer_portal)
  end

end
