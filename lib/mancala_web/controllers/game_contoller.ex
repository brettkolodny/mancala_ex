defmodule MancalaWeb.GameController do
  use MancalaWeb, :controller

  import Phoenix.LiveView.Controller

  plug :authenticate_player when action in [:show]

  def show(conn, _params) do
    render(conn, "game.html")
  end
end
