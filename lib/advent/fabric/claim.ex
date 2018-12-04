defmodule Advent.Fabric.Claim do
  alias __MODULE__

  defstruct [:claim_id, :coordinates]

  # 1 @ 817,273: 26x26
  def new(claim) do
    %{
      "claim_id" => claim_id,
      "left_edge" => left_edge,
      "top_edge" => top_edge,
      "wide" => wide,
      "tall" => tall
    } =
      Regex.named_captures(
        ~r/#(?<claim_id>[0-9]+) @ (?<left_edge>[0-9]+),(?<top_edge>[0-9]+): (?<wide>[0-9]+)x(?<tall>[0-9]+)/,
        claim
      )

    %Claim{
      claim_id: String.to_integer(claim_id),
      coordinates:
        expand_claim(
          String.to_integer(left_edge),
          String.to_integer(top_edge),
          String.to_integer(wide),
          String.to_integer(tall)
        )
    }
  end

  def expand_claim(left_edge, top_edge, wide, tall) do
    coordinates = MapSet.new()

    Enum.reduce(Range.new(left_edge + 1, left_edge + wide), coordinates, fn col, coord ->
      Enum.reduce(Range.new(top_edge + 1, top_edge + tall), coord, fn row, coord ->
        MapSet.put(coord, Advent.Fabric.Coordinate.new(row, col))
      end)
    end)
  end
end
