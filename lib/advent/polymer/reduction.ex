defmodule Advent.Polymer.Reduction do
  def optimize() do
    load_file()
    |> improve_react()
    |> Enum.sort()
    |> List.first()
  end

  def improve_react(list) do
    ?A..?Z
    |> Enum.reduce([], fn x, acc ->
      improved_list =
        Enum.filter(list, fn element ->
          uppercase = x
          lowercase = x + 32
          not (element == uppercase or element == lowercase)
        end)

      [react(improved_list) | acc]
    end)
  end

  def trigger() do
    load_file()
    |> react()
  end

  def react(list) do
    list
    |> Enum.reduce([], fn x, stack ->
      reduce(x, stack)
    end)
    |> Enum.count()
  end

  def reduce(x, []), do: [x]

  def reduce(x, [head | tail]) do
    case abs(head - x) == 32 do
      true -> tail
      false -> [x, head | tail]
    end
  end

  def load_file() do
    "../../../assets/input5.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> to_charlist()
  end
end
