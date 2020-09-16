defmodule MancalaWeb.SessionController do
  use MancalaWeb, :controller

  alias MancalaWeb.Router.Helpers, as: Routes
  alias Mancala.Game.Player
  alias Mancala.GameSupervisor
  alias MancalaWeb.Auth

  def new_player(conn, _params) do
    render(conn, "new_player.html")
  end

  def new_game(conn, _params) do
    render(conn, "new_game.html")
  end

  def create_game(conn, %{ "game_name" => game_name }) do
    game_name = URI.encode(game_name)
    case Registry.lookup(Mancala.GameRegistry, game_name) do
      [] ->
        GameSupervisor.start_game(game_name)
        conn
        |> put_session(:game_name, game_name)
        |> redirect(to: Routes.game_path(conn, :show, game_name))

      _ ->
        conn
        |> put_flash(:error, "A game already exists with this name.")
        |> redirect(to: Routes.session_path(conn, :new_game))
    end
  end

  def create_player(conn, %{ "player_name" => player_name, "color" => color }) when player_name != "" and color != "" do
    crsf_token = get_session(conn, "_csrf_token")
    player = Player.new(player_name, color, crsf_token)
    conn = Auth.login(conn, player)

    case get_session(conn, "game_name") do
      nil ->
        if Map.has_key?(get_session(conn), "request_path") do
          request_path_split = String.split(get_session(conn, :request_path), "/")
          conn =
            case request_path_split do
              ["", "games", game_name] -> put_session(conn, "game_name", game_name)
              _ ->
                conn
            end

          redirect(conn, to: get_session(conn, "request_path"))
        else
          redirect(conn, to: Routes.session_path(conn, :new_game))
        end
      game_name -> redirect(conn, to: Routes.game_path(conn, :show, game_name))
    end
  end

  def create_player(conn, _params) do
    conn
    |> put_flash(:error, "Please enter a name and color.")
    |> redirect(to: Routes.session_path(conn, :new_player))
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout
    |> redirect(to: Routes.session_path(conn, :new_game))
  end
end
