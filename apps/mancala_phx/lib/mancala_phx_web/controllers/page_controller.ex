defmodule MancalaPhxWeb.PageController do
  use MancalaPhxWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
