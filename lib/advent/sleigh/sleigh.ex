defmodule Advent.Sleigh do
  import NimbleParsec

  def load_dependecies do
    "../../../assets/input7.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      {:ok, [start, next], "", %{}, _, _} = dependecy(line)
      {start, next}
    end)
    |> Enum.sort_by(fn {start, _next} -> start end)
    |> sequence_of_parts()

    # |> sequence_of_parts([], [])
  end

  def sequence_of_parts(list) do
    start = Enum.sort(find_start(list))

    for part <- start do
      {part, Enum.sort(find_next(list, part))}
    end
  end

  def reduce_list({start, _next}, start), do: false
  def reduce_list({_start, _next}, _part), do: true

  def find_start(list) do
    start_list = Enum.sort(Enum.uniq(Enum.map(list, fn {start, _next} -> start end)))
    next_list = Enum.sort(Enum.uniq(Enum.map(list, fn {_start, next} -> next end)))

    Enum.reduce(next_list, start_list, fn element, acc ->
      List.delete(acc, element)
    end)
  end

  def find_next(list, prev) do
    Enum.filter(list, fn {start, _next} ->
      start == prev
    end)
    |> Enum.map(fn {_start, next} -> next end)
  end

  defparsec(
    :dependecy,
    ignore(string("Step "))
    |> ascii_string([?A..?Z], 1)
    |> ignore(string(" must be finished before step "))
    |> ascii_string([?A..?Z], 1)
    |> ignore(string(" can begin.")),
    debug: false
  )
end
