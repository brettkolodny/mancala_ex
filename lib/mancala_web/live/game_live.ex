defmodule MancalaWeb.GameLive do
  use MancalaWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    IO.inspect(assigns)
    ~L"""
      <div id="board-container">
        <div id="game-board">
          <div id="player1-store" class="player-store"></div>
          <%= for _ <- 0..5 do %>
            <div class="square">
              <div class="stone p1">4</div>
            </div>
          <% end %>
          <%= for _ <- 0..5 do %>
            <div class="square">
              <div class="stone p2">4</div>
            </div>
          <% end %>
          <div id="player2-store" class="player-store"></div>
        </div>
      </div>
    """
  end
end
