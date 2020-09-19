defmodule Mancala.Game.Player do
  alias __MODULE__

  defstruct [:name, :color, :csrf_token]

  def new(name, color, csrf) do
    %Player{ name: name, color: color, csrf_token: csrf }
  end
end
