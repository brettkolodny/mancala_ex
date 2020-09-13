defmodule MancalaWeb.Router do
  use MancalaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MancalaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
        plug MancalaWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MancalaWeb do
    pipe_through :browser

    get "/", SessionController, :new_game
    get "/sessions/new-player", SessionController, :new_player
    post "/create-game", SessionController, :create_game
    post "/create-player", SessionController, :create_player
    resources "/sessions", SessionController, only: [:delete]
    resources "/games", GameController, only: [:show]

    live "/game", GameLive

    # live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MancalaWeb do
  #   pipe_through :api
  # end

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
      live_dashboard "/dashboard", metrics: MancalaWeb.Telemetry
    end
  end
end
