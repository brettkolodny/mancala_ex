defmodule MancalaWeb.GameLive do
  use MancalaWeb, :live_view

  def mount(_params, session = %{"player" => player, "game_name" => game_name}, socket) do
    IO.inspect(session)
    IO.puts("Mouting*******************************")
    game_via_tuple = Mancala.GameServer.via_tuple(game_name)

    Mancala.GameServer.add_player(game_via_tuple, player)
    game = Mancala.GameServer.get_game(game_via_tuple)

    MancalaWeb.Endpoint.subscribe(game_name)
    MancalaWeb.Endpoint.broadcast_from(self(), game_name, "update", game)

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

    IO.inspect(game)

    MancalaWeb.Endpoint.broadcast_from(self(), socket.assigns.game_name, "update", game)
    {:noreply, socket}
  end

  def handle_info(%{event: "update", payload: game}, socket) do
    {:noreply, assign(socket, :game, game)}
  end

  def render(assigns) do
    ~L"""
      <h1>
        <%= if @game.player1_turn do %>
          <%= @game.player1.name || "Player 1" %>'s turn
        <% else %>
          <%= @game.player2.name || "Player 2" %>'s turn
        <% end %>
      </h1>
      <div id="board-container">
        <div id="game-board">
          <div id="player1-store" class="player-store">
            <div class="stone <%= @game.player2.color || 'yellow' %> score">
              <%= Enum.at(@game.board, 0) %>
            </div>
          </div>

          <%= for num_square <- 1..6 do %>
            <div class="square">

              <%= case Enum.at(@game.board, num_square) do %>
                <% 0 -> %>
                  <div></div>
                <% num_stones -> %>
                  <div class="stone <%= @game.player1.color || 'yellow' %>" phx-value-square=<%= num_square %> phx-click="turn">
                    <%= num_stones %>
                  </div>
              <% end %>

            </div>
          <% end %>

          <%= for num_square <- 13..8 do %>
            <div class="square">

              <%= case Enum.at(@game.board, num_square) do %>
                <% 0 -> %>
                  <div></div>
                <% num_stones -> %>
                  <div class="stone <%= @game.player2.color || 'yellow' %>" phx-value-square=<%= num_square %> phx-click="turn">
                    <%= num_stones %>
                  </div>
              <% end %>

            </div>
          <% end %>

          <div id="player2-store" class="player-store">
            <div class="stone <%= @game.player1.color || 'yellow' %> score">
              <%= Enum.at(@game.board, 7) %>
            </div>
          </div>
        </div>
      </div>
    """
  end
end
