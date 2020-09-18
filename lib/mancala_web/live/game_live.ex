defmodule MancalaWeb.GameLive do
  use MancalaWeb, :live_view

  def mount(_params, %{"player" => player, "game_name" => game_name}, socket) do
    game_via_tuple = Mancala.GameServer.via_tuple(game_name)

    Mancala.GameServer.add_player(game_via_tuple, player)
    game = Mancala.GameServer.get_game(game_via_tuple)

    MancalaWeb.Endpoint.subscribe(game_name)
    MancalaWeb.Endpoint.broadcast_from(self(), game_name, "update", game)

    socket =
      socket
      |> assign(:current_player, player)
      |> assign(:game_name, game_name)
      |> assign(:game, game)
      |> assign(:game_via_tuple, game_via_tuple)
      |> assign(:game_terminated, false)

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

  def handle_info(%{event: "update", payload: game}, socket) do
    {:noreply, assign(socket, :game, game)}
  end

  def handle_info(%{event: "game-terminated"}, socket) do
    {:noreply, assign(socket, :game_terminated, true)}
  end

  def render(assigns) do
    ~L"""
      <script>
        function copyText() {
          const gameLink = document.getElementById("link-text");

          gameLink.select();

          document.execCommand("copy");
        }
      </script>
      <%= if @game_terminated do %>
        <h1>Game over</h1>
      <% else %>
        <div id="game-container">
          <div id="game-link">
            <input type="text"id="link-text" readonly value="localhost:4000/games/<%= @game_name %>">
            <div id="copy-button" onClick="copyText()">Copy</div>
          </div>
          <h1>
            <%= case @game.winner do %>
              <% {false, _} -> %>
                <%= if @game.player1_turn do %>
                  <%= @game.player1.name || "Player 1" %>'s turn
                <% else %>
                  <%= @game.player2.name || "Player 2" %>'s turn
                <% end %>
              <% {true, winner} -> %>
                <%= winner %> wins!
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
                      <%= content_tag(
                        :div,
                        num_stones,
                        [
                          class: [
                            "stone ",
                            @game.player1.color || "yellow",
                            (if @current_player == @game.player1, do: " clickable", else: "")
                          ],
                          "phx-value-square": num_square,
                          "phx-click": (if @current_player == @game.player1, do: "turn", else: nil)
                        ]
                      ) %>
                  <% end %>

                </div>
              <% end %>

              <%= for num_square <- 13..8 do %>
                <div class="square">

                  <%= case Enum.at(@game.board, num_square) do %>
                    <% 0 -> %>
                      <div></div>
                    <% num_stones -> %>
                      <%= content_tag(
                        :div,
                        num_stones,
                        [
                          class: [
                            "stone ",
                            @game.player2.color || "yellow",
                            (if @current_player == @game.player2, do: " clickable", else: "")
                          ],
                          "phx-value-square": num_square,
                          "phx-click": (if @current_player == @game.player2, do: "turn", else: nil)
                        ]
                      ) %>
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
        </div>
      <% end %>
    """
  end
end
