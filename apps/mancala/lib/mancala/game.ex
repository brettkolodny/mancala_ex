defmodule Mancala.Game do
  defstruct board: [], player1_turn: true, player1: "", player2: ""

  defp build_board do
    [0, 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4]
  end

  def new(player1, player2) do
    %Mancala.Game{ board: build_board(), player1: player1, player2: player2 }
  end

  def take_turn(%{board: board, player1_turn: turn} = game, start) do
    {board, extra_turn} = TurnUtility.take_turn(board, start, turn)

    case extra_turn do
      true -> %{ game | board: board }
      false -> %{ game | board: board, player1_turn: !turn }
    end
  end
end
