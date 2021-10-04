defmodule RequestError do
  @moduledoc false
  defexception [:message]
end

defmodule ApiRequest do

  def finish_request(ref) do
    {:ok, body} = :hackney.body(ref)
    body
  end

  def loop(ref) do
    :hackney.stream_next(ref)
    receive do
      {:hackney_response, ^ref, {:headers, headers}} ->
        {:ok, ref} = :hackney.stop_async(ref)
        finish_request(ref)
    end
  end

  def request(url, method \\ :get, headers \\ [], body \\ "", timeout \\ 10) do
    body =
      case body do
        b when is_map(b) -> Jason.encode!(b)
        b when is_binary(b) -> b
        b -> ""
      end
    pool = :marvel_pool
    timeout = timeout * 1000
    options = [async: :once, connect_timeout: timeout, recv_timeout: timeout, pool: pool]
    {:ok, ref} = :hackney.request(method, url, headers, body, options)

    receive do
      {:hackney_response, ^ref, {:status, status, _reason}} ->
        body = loop(ref)
        case Jason.decode(body) do
          {:ok, val} -> {status, val}
          {:error, error} -> {403, "decode error"}
        end
      val ->
        :hackney.stop_async(ref)
        {403, "internal service is busy"}
    after
      timeout ->
        :hackney.stop_async(ref)
        {403, %{"error" => "request timeout"}}
    end
  rescue e ->
    {403, "undefined error: #{inspect(e)}"}
  end

  def request!(url, method, headers, body, timeout \\ 5) do
    case request(url, method, headers, body, timeout) do
      {200, response} ->
        response
      {x, y} ->
        raise RequestError, message: "#{x}, #{inspect(y)}"
      x ->
        raise RequestError, message: "undefined error"
    end
  end
end
