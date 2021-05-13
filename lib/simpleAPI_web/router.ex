defmodule SimpleAPIWeb.Router do
  use SimpleAPIWeb, :router

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


  pipeline :api_protected do
    plug :accepts, ["json"]
    plug SimpleAPIWeb.Auth_plug, otp_app: :SimpleAPI
  end


  scope "/", SimpleAPIWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

   scope "/api", SimpleAPIWeb do
     pipe_through :api

     resources "/users",UserController, only: [:create]

  end
  scope "/api", SimpleAPIWeb do
     pipe_through [:api, :api_protected ]
     resources "/users",UserController, only: [:update, :delete, :show,:index]

   end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SimpleAPIWeb.Telemetry
    end
  end
end
