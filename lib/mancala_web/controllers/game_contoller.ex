defmodule MancalaWeb.GameController do
  use MancalaWeb, :controller

  plug :authenticate_player when action in [:show]

  def show(conn, params) do
    IO.inspect params
    render(conn, "game.html")
  end
end