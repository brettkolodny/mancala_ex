defmodule MancalaEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: MancalaEx.PubSub}
      # Start a worker by calling: MancalaEx.Worker.start_link(arg)
      # {MancalaEx.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MancalaEx.Supervisor)
  end
end