defmodule MancalaWeb.GameController do
  use MancalaWeb, :controller

  import Phoenix.LiveView.Controller

  plug :authenticate_player when action in [:show]

  def show(conn, params) do
    IO.inspect params
    live_render(conn, MancalaWeb.GameLive, session: get_session(conn))
  end
end
