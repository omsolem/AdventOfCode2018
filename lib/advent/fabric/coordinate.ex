defmodule Advent.Fabric.Coordinate do
  alias __MODULE__

  defstruct [:row, :col]

  def new(row, col), do: %Coordinate{row: row, col: col}
end
