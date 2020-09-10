defmodule Mancala.Game.Player do
  alias __MODULE__

  defstruct [:name, :color]

  def new(name, color) do
    %Player{ name: name, color: color }
  end
end