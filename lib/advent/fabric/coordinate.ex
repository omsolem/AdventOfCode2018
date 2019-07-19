defmodule Advent.Fabric.Coordinate do
  alias __MODULE__

  defstruct [:row, :col]

  def new(row, col) when is_integer(row) and is_integer(col), do: %Coordinate{row: row, col: col}
end
