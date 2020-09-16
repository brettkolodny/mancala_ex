defmodule MancalaWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias MancalaWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
      player = get_session(conn, :player)
      assign(conn, :current_player, player)
  end

  def authenticate_player(conn, _opts) do
    if conn.assigns.current_player do
        conn
    else
        conn
        |> put_session(:request_path, conn.request_path)
        |> redirect_to_new_player
        |> halt
    end
  end

  defp redirect_to_new_player(conn) do
    redirect(conn, to: Routes.session_path(conn, :new_player))
  end

  def login(conn, player) do
      conn
      |> assign(:current_player, player)
      |> put_session(:player, player)
      |> configure_session(renew: true)
  end

  def logout(conn) do
      configure_session(conn, drop: true)
  end
end
