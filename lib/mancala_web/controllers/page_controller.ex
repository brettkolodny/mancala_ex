defmodule MancalaWeb.PageController do
  use MancalaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
