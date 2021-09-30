defmodule MarvelGateway.Repo do
  use Ecto.Repo,
    otp_app: :marvel_gateway,
    adapter: Ecto.Adapters.Postgres
end
