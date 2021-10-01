defmodule MarvelGatewayWeb.Router do
  use MarvelGatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug MarvelGateway.Auth
  end

  scope "/api", MarvelGatewayWeb.Api.V1 do
    pipe_through [:api, :auth]

    scope "/v1" do
      resources("/characters", CharacterController, except: [:new, :edit, :update])
    end
  end
end
