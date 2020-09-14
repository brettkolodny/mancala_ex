defmodule MancalaWeb.GameController do
  use MancalaWeb, :controller

  plug :authenticate_player when action in [:show]
  def show(conn, _params) do
    render(conn, "game.html")
  end
end
