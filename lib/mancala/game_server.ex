defmodule Mancala.GameServer do

  @name :game_server
  alias Elixir.TurnUtility
  alias Mancala.Game

  use GenServer

  # Server code
  def start_link(game_name) do
    IO.puts "Starting GameServer"
    game = Game.new()

    GenServer.start_link(__MODULE__, game, name: via_tuple(game_name))
  end

  def init(game) do
    {:ok, game}
  end

  def handle_call({:take_turn, square}, _from, game) do
    new_game_state = Mancala.Game.take_turn(game, square)

    {:reply, new_game_state, new_game_state}
  end

  def handle_call(:get_board, _from, game) do
    {:reply, game, game}
  end

  def handle_call({:add_player, player}, _from, game) do
    game = Mancala.Game.add_player(game, player)
    {:reply, game, game}
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
  def take_turn(via_tuple, square) do
    GenServer.call(via_tuple, {:take_turn, square})
  end

  def add_player(via_tuple, player) do
    GenServer.call(via_tuple, {:add_player, player})
  end

  def get_game(via_tuple) do
    GenServer.call(via_tuple, :get_board)
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
    string <> square <> player_store
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

  def via_tuple(game_name) do
    {:via, Registry, {Mancala.GameRegistry, game_name}}
  end

end
