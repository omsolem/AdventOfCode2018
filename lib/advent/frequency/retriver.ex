defmodule Advent.Frequency.Retriver do
  use Agent

  def start_link(_) do
    Agent.start_link(&load/0, name: __MODULE__)
  end

  defp load() do
    "../../../assets/input.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer(&1))
  end

  def fetch() do
    Agent.get(__MODULE__, fn list -> list end)
  end

  def next() do
    Agent.get_and_update(__MODULE__, fn [head | tail] -> {head, rotate_list([head | tail])} end)
  end

  defp rotate_list([head | tail]) do
    tail
    |> List.flatten([head])
  end
end
