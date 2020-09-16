defmodule Mancala.Game do
  alias Mancala.Game.Player

  defstruct board: [0, 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4], player1_turn: true, player1: %Player{}, player2: %Player{}

  def new() do
    %Mancala.Game{}
  end

  def player_already_connected?(%{player1: player1, player2: player2}, %{csrf_token: csrf_token}) do
    if player1.csrf_token == csrf_token or player2.csrf_token == csrf_token do
      true
    else
      false
    end
  end

  def add_player(game, player) do
    if player_already_connected?(game, player) do
      game
    else
      add_new_player(game, player)
    end
  end

  defp add_new_player(game = %Mancala.Game{ player1: %{csrf_token: crsf} }, player) when crsf == nil do
    %Mancala.Game{ game | player1: player }
  end

  defp add_new_player(game = %Mancala.Game{ player2: %{csrf_token: crsf} }, player) when crsf == nil do
    %Mancala.Game{ game | player2: player }
  end

  defp add_new_player(game, _player) do
    game
  end

  def take_turn(%{board: board, player1_turn: turn} = game, start) do
    {board, extra_turn} = TurnUtility.take_turn(board, start, turn)

    case extra_turn do
      true -> %{ game | board: board }
      false -> %{ game | board: board, player1_turn: !turn }
    end
  end
end
