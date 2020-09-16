defmodule MancalaWeb.GameController do
  use MancalaWeb, :controller

  plug :authenticate_player when action in [:show]
  def show(conn, %{"id" => game_name}) do
    conn
    |> put_session("game_name", game_name)
    |> render("game.html")
  end
end
