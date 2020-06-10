defmodule GameServerTest do
  use ExUnit.Case
  
  alias Mancala.GameServer, as: Server

  test "extra turn" do
    {:ok, pid} = Server.start()
  
    Server.take_turn(3)

    game = Server.get_game()

    assert game.player1_turn == true

    Server.take_turn(4)

    game = Server.get_game()

    assert game.player1_turn == false



  end
end
