defmodule MancalaWeb.GameLive do
  use MancalaWeb, :live_view

  def mount(_params, session = %{"game_name" => game_name}, socket) do
    IO.inspect(session)
    game_via_tuple = Mancala.GameServer.via_tuple(game_name)
    game = Mancala.GameServer.get_game(game_via_tuple)

    MancalaWeb.Endpoint.subscribe(game_name)

    socket =
      socket
      |> assign(:game_name, game_name)
      |> assign(:game, game)
      |> assign(:game_via_tuple, game_via_tuple)

    {:ok, socket}
  end

  def handle_event("turn", %{"square" => square}, socket) do
    square = String.to_integer(square)
    game_via_tuple = socket.assigns.game_via_tuple
    game = Mancala.GameServer.take_turn(game_via_tuple, square)
    socket = assign(socket, :game, game)

    MancalaWeb.Endpoint.broadcast_from(self(), socket.assigns.game_name, "update", game)
    {:noreply, socket}
  end

  def handle_event("update", game, socket) do
    {:noreply, assign(socket, :game, game)}
  end

  def render(assigns) do
    ~L"""
      <h1>
        <%= if @game.player1_turn do %>
          Player 1's turn
        <% else %>
          Player 2's turn
        <% end %>
      </h1>
      <div id="board-container">
        <div id="game-board">
          <div id="player1-store" class="player-store">
            <div class="stone p1 score">
              <%= Enum.at(@game.board, 0) %>
            </div>
          </div>
          <%= for num_square <- 1..6 do %>
              <div class="square">
                <div class="stone p1" phx-value-square=<%= num_square %> phx-click="turn">
                  <%= Enum.at(@game.board, num_square) %>
                </div>
              </div>
          <% end %>
          <%= for num_square <- 13..8 do %>
            <div class="square">
              <div class="stone p1" phx-value-square=<%= num_square %> phx-click="turn">
                <%= Enum.at(@game.board, num_square) %>
              </div>
            </div>
          <% end %>
          <div id="player2-store" class="player-store">
            <div class="stone p1">
              <%= Enum.at(@game.board, 7) %>
            </div>
          </div>
        </div>
      </div>
    """
  end
end
