defmodule Mancala.GameServer do

  @name :game_server
  alias Elixir.TurnUtility
  alias Mancala.Game

  use GenServer

  # Server code
  def start do
    IO.puts "Starting server..."
    GenServer.start(__MODULE__, %Game{}, name: @name)
  end

  def init(_game) do
    {:ok, Game.new("p1", "p2")}
  end

  def handle_call({:take_turn, square}, _from, game) do
    {new_board, extra_turn} = TurnUtility.take_turn(game.board, square, game.player1_turn)

    new_game_state =
      case extra_turn do
        true -> %{ game | board: new_board }
        false -> %{ game | player1_turn: !game.player1_turn, board: new_board }
      end

    {:reply, new_game_state, new_game_state}
  end

  def handle_cast(:print_game, game) do
    IO.inspect game
    {:noreply, game}
  end

  def handle_cast(:print_board, game) do
    print_board_utility(game.board)
    {:noreply, game}
  end

  # Client code
  def take_turn(square) do
    GenServer.call(@name, {:take_turn, square})
  end

  def print_game do
    GenServer.cast(@name, :print_game)
  end

  def print_board do
    GenServer.cast(@name, :print_board)
  end

  # Utility
  def print_board_utility(board) do
    board_string = print_board_utility(board, 0, "")
    IO.puts(board_string)
    board_string = print_board_utility(board, 13, "")
    IO.puts(board_string <> "\n")
  end

  def print_board_utility(board, 7, string) do
    string <> Integer.to_string(Enum.at(board, 7))
  end

  def print_board_utility(board, index, string) when index < 8 do
    square = Enum.at(board, index) |> Integer.to_string
    new_string = string <> square
    print_board_utility(board, index + 1, new_string)
  end

  def print_board_utility(board, 8, string) do
    square = Enum.at(board, 8) |> Integer.to_string
    player_store = Enum.at(board, 7) |> Integer.to_string

    new_string = string <> square <> player_store 
  end

  def print_board_utility(board, 13, string) do
    square = Enum.at(board, 13) |> Integer.to_string
    player_store = Enum.at(board, 0) |> Integer.to_string

    new_string = player_store <> string <> square

    print_board_utility(board, 12, new_string)
  end

  def print_board_utility(board, index, string) do
    square = Enum.at(board, index) |> Integer.to_string
    new_string = string <> square
    print_board_utility(board, index - 1, new_string)
  end

end

alias Mancala.GameServer

{:ok, _pid} = GameServer.start()

GameServer.print_board()
GameServer.take_turn(3)
GameServer.print_board()
GameServer.take_turn(4)
GameServer.print_board()
