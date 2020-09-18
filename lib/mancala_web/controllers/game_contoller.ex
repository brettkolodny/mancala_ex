defmodule MancalaWeb.GameController do
  use MancalaWeb, :controller

  plug :authenticate_player when action in [:show]

  def show(conn, %{"id" => game_name}) do
    game_via_tuple = Mancala.GameServer.via_tuple(game_name)

    case GenServer.whereis(game_via_tuple) do
      nil ->
        conn
        |> put_flash(:error, "This game does not exist.")
        |> redirect(to: Routes.session_path(conn, :new_game))

      _ ->
        conn
        |> put_session("game_name", game_name)
        |> render("game.html")
    end
  end
end
