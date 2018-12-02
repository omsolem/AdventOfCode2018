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

  defp id_checksum(boxid) do
    String.split(boxid, "", trim: true)
    |> Enum.sort()
    |> Enum.reduce(%{}, &group_element(&2, &1))
    |> Enum.filter(fn {_, value} -> value == 2 or value == 3 end)
    |> Enum.dedup_by(fn {_, value} -> value end)
    |> Enum.reduce([], fn {_, value}, list -> [value | list] end)
    |> Enum.sort()
  end

  defp group_element(map, element) do
    {_, new_map} =
      Map.get_and_update(map, element, fn current_value -> increment_element(current_value) end)

    new_map
  end

  defp increment_element(nil), do: {nil, 1}
  defp increment_element(value), do: {value, value + 1}

  defp get_box_ids() do
    "../../../assets/input2.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n")
  end

  defp differ_by_exactly_one_character(eq: id_before, del: char1, ins: _, eq: id_after) do
    case Enum.count(char1) == 1 do
      true ->
        List.to_string(id_before ++ id_after)

      false ->
        ""
    end
  end

  defp differ_by_exactly_one_character(_) do
    ""
  end

  def find_prototype_fabric() do
    get_box_ids()
    |> Enum.map(&String.to_charlist/1)
    |> compare_ids([])
    |> List.flatten()
  end

  defp compare_ids([], common_chars), do: common_chars

  defp compare_ids([head | tail], common_chars) do
    new_common_chars =
      tail
      |> Enum.reduce([], &compare_id(&2, head, &1))
      |> List.flatten()

    compare_ids(tail, [new_common_chars | common_chars])
  end

  defp compare_id(acc, head, element) do
    case differ_by_exactly_one_character(List.myers_difference(head, element)) do
      "" -> acc
      common_chars -> [common_chars | acc]
    end
  end
end
