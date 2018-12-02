defmodule Advent.Frequency.Finder do
  def calculate_total() do
    Advent.Frequency.Retriver.fetch()
    |> Enum.sum()
  end

  def first_frequency_twice do
    first_frequency_twice(0)
  end

  def first_frequency_twice(current_fequency)
      when is_integer(current_fequency) do
    first_frequency_twice(current_fequency, MapSet.new([current_fequency]), false)
  end

  defp first_frequency_twice(
         current_fequency,
         seen_frequencies,
         false
       ) do
    new_current_frequency = current_fequency + Advent.Frequency.Retriver.next()

    first_frequency_twice(
      new_current_frequency,
      MapSet.put(seen_frequencies, new_current_frequency),
      MapSet.member?(seen_frequencies, new_current_frequency)
    )
  end

  defp first_frequency_twice(current_fequency, _, true), do: current_fequency
end
