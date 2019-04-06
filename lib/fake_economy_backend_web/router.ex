defmodule FakeEconomyBackendWeb.Router do
  use FakeEconomyBackendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: FakeEconomyBackendWeb.Schema

    forward "/", Absinthe.Plug,
      schema: FakeEconomyBackendWeb.Schema
  end
end
