defmodule MancalaExTest do
  use ExUnit.Case
  doctest MancalaEx

  test "greets the world" do
    assert MancalaEx.hello() == :world
  end
end
