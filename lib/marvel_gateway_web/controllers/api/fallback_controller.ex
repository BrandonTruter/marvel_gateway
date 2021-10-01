defmodule MarvelGatewayWeb.Api.FallbackController do
  use Phoenix.Controller
  alias MarvelGatewayWeb.ErrorView

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(ErrorView, :"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(403)
    |> render(ErrorView, :"403")
  end

  def call(conn, {:error, _}) do
    conn
    |> put_status(500)
    |> render(ErrorView, :"500")
  end
end
