defmodule Advent.Fabric.Plan do
  def find_number_of_overlap() do
    load_claims()
    |> find_overlap_claims(MapSet.new())
    |> Enum.count()
  end

  def find_overlap_claim(%Advent.Fabric.Claim{coordinates: coordinates1}, %Advent.Fabric.Claim{
        coordinates: coordinates2
      }) do
    MapSet.intersection(coordinates1, coordinates2)
  end

  def find_overlap_claims([], overlap), do: overlap

  def find_overlap_claims([head | tail], overlap) do
    find_overlap_claims(
      tail,
      Enum.reduce(tail, overlap, fn x, acc ->
        MapSet.union(acc, find_overlap_claim(head, x))
      end)
    )
  end

  def find_nonoverlapping() do
    load_claims()
    |> find_nonoverlap_claimid()
  end

  def find_nonoverlap_claimid(list) do
    Enum.reduce_while(list, 0, fn claim_outer = %Advent.Fabric.Claim{claim_id: claim_id_outer},
                                  acc ->
      overlap =
        Enum.reduce(list, 0, fn claim_inner = %Advent.Fabric.Claim{claim_id: claim_id_inner},
                                acc ->
          case claim_id_outer == claim_id_inner do
            true -> acc + 0
            false -> acc + MapSet.size(find_overlap_claim(claim_outer, claim_inner))
          end
        end)

      case overlap == 0 do
        true -> {:halt, claim_id_outer}
        false -> {:cont, 0}
      end
    end)
  end

  def load_claims() do
    "../../../assets/input3.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&Advent.Fabric.Claim.new/1)
  end
end
