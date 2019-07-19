defmodule Advent.Critical.Finite do
  def manhattan_distance({row1, col1}, {row2, col2}), do: abs(col1 - col2) + abs(row1 - row2)

  def dangerous() do
    load_coordinates()
    |> calculate_grid()
    |> Enum.group_by(fn {lable, _x, _y} -> lable end)
    |> Enum.map(fn {lable, list} ->
      {lable, Enum.count(list)}
    end)
    |> Enum.sort_by(fn {_lable, area_size} -> -area_size end)
    |> List.first()
  end

  def safe() do
    load_coordinates()
    |> sum_grid()
    |> Enum.filter(fn {sum, _x, _y} -> sum < 10_000 end)
    |> Enum.count()
  end

  def load_coordinates do
    "../../../assets/input6.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n")
    |> Enum.reduce(MapSet.new(), fn coordinate, map_set ->
      [row, col | []] = String.split(coordinate, ", ")

      MapSet.put(
        map_set,
        {String.to_integer(row), String.to_integer(col)}
      )
    end)
    |> lable_coordinates()
  end

  def calculate_grid(coord_list) do
    {{min_row, min_col}, {max_row, max_col}} = min_max(coord_list)

    for x <- min_row..max_row, y <- min_col..max_col do
      lable =
        Enum.map(coord_list, fn {lable, coord_x, coord_y} ->
          {lable, manhattan_distance({x, y}, {coord_x, coord_y})}
        end)
        |> Enum.sort_by(fn {_lable, distance} -> distance end)
        |> Enum.take(2)
        |> find_lable()

      {lable, x, y}
    end
  end

  def sum_grid(coord_list) do
    # {{min_row, min_col}, {max_row, max_col}} = min_max(coord_list)
    # Brute force bounding box to find number - extending beyond the bounding box in Step 1
    for x <- -2000..2000, y <- -2000..2000 do
      sum =
        Enum.map(coord_list, fn {_lable, coord_x, coord_y} ->
          manhattan_distance({x, y}, {coord_x, coord_y})
        end)
        |> Enum.sum()

      {sum, x, y}
    end
  end

  def find_lable([{_, distance}, {_, distance} | []]), do: :equal

  def find_lable([{lable1, distance1}, {lable2, distance2} | []]) do
    case distance1 > distance2 do
      true -> lable2
      false -> lable1
    end
  end

  def min_max_row(list), do: Enum.min_max_by(list, fn {_lable, row, _col} -> row end)

  def min_max_col(list), do: Enum.min_max_by(list, fn {_lable, _row, col} -> col end)

  def min_max(map_set) do
    {{_, min_row, _}, {_, max_row, _}} = min_max_row(map_set)

    {{_, min_col, _}, {_, max_col, _}} = min_max_col(map_set)

    {{min_row, min_col}, {max_row, max_col}}
  end

  def lable_coordinates(list) do
    lables = Range.new(1, Enum.count(list))

    for lable <- lables do
      {:ok, {x, y}} = Enum.fetch(list, lable - 1)
      {lable, x, y}
    end
  end
end
