defmodule Mancala.Game do
  alias Mancala.Game.Player

  defstruct board: [0, 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4], player1_turn: true, player1: %Player{}, player2: %Player{}

  def new() do
    %Mancala.Game{}
  end

  def add_player(game = %Mancala.Game{ player1: nil }, player) do
    %Mancala.Game{ game | player1: player }
  end

  def add_player(game = %Mancala.Game { player2: nil }, player) do
    %Mancala.Game{ game | player2: player }
  end

  def take_turn(%{board: board, player1_turn: turn} = game, start) do
    {board, extra_turn} = TurnUtility.take_turn(board, start, turn)

    case extra_turn do
      true -> %{ game | board: board }
      false -> %{ game | board: board, player1_turn: !turn }
    end
  end
end
  