defmodule Mancala do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Mancala.GameRegistry},
      Mancala.GameSupervisor
    ]

    opts = [strategy: :one_for_one, name: Mancala.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
