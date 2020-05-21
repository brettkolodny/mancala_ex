defmodule TurnUtility do
  use Rustler, otp_app: :mancala_ex, crate: "turnutility"

  def take_turn(_board, _start, _player_one), do: :erlang.nif_error(:nif_not_loaded)
end
