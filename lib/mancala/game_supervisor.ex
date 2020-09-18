defmodule Mancala.GameSupervisor do
  use DynamicSupervisor

  alias Mancala.GameServer

  def start_link(_args) do
    IO.puts "Starting GameSupervisor..."
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_game(game_name) do
    child_spec = %{
      id: GameServer,
      start: {GameServer, :start_link, [game_name]},
      restart: :transient
    }

    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, child_spec)

    spawn(fn ->
      :timer.sleep(3600000)
      MancalaWeb.Endpoint.broadcast_from(self(), game_name, "game-terminated", %{})
      DynamicSupervisor.terminate_child(Mancala.GameSupervisor, pid)
    end)

    {:ok, pid}
  end
end
