defmodule Advent.BoxID do
  def file_checksum() do
    get_box_ids()
    |> Enum.map(&id_checksum(&1))
    |> List.flatten()
    |> Enum.sort()
    |> Enum.chunk_by(fn elem -> elem end)
    |> Enum.map(fn list -> Enum.count(list) end)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  def id_checksum(boxid) do
    String.split(boxid, "", trim: true)
    |> Enum.sort()
    |> Enum.reduce(%{}, &group_element(&2, &1))
    |> Enum.filter(fn {_, value} -> value == 2 or value == 3 end)
    |> Enum.dedup_by(fn {_, value} -> value end)
    |> Enum.reduce([], fn {_, value}, list -> [value | list] end)
    |> Enum.sort()
  end

  def group_element(map, element) do
    {_, new_map} =
      Map.get_and_update(map, element, fn current_value -> increment_element(current_value) end)

    new_map
  end

  def increment_element(nil), do: {nil, 1}
  def increment_element(value), do: {value, value + 1}

  def get_box_ids() do
    "../../assets/input2.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n")
  end

  def differ_by_exactly_one_character(eq: id_before, del: char1, ins: _, eq: id_after) do
    case Enum.count(char1) == 1 do
      true -> [id_before | id_after]
      false -> nil
    end
  end
end
