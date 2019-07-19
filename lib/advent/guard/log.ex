defmodule Advent.Guard.Log do
  alias Advent.Guard.Record

  def strategy2() do
    day4_data()
    |> prepare_log()
    |> Enum.reduce({0, 0, 0}, &find_guard_and_minute_for_most_times_sleeping/2)
  end

  def strategy1() do
    day4_data()
    |> prepare_log()
    |> Enum.reduce({0, 0, 0}, &find_guard_and_minute_for_most_sleeping/2)
  end

  def prepare_log(list) do
    list
    |> Enum.map(&Advent.Guard.Record.new/1)
    |> sort_guard_log()
    |> fill_in_guard_id(nil, [])
    |> sort_guard_log()
    |> enum_sleeping_minutes_pr_guard(%{})
  end

  def find_guard_and_minute_for_most_sleeping({key, value}, {guard_id, index, sum}) do
    new_sum = Enum.sum(value)

    case new_sum > sum do
      true ->
        max_value = Enum.max(value)
        new_index = Enum.find_index(value, fn x -> x == max_value end)
        {key, new_index, new_sum}

      false ->
        {guard_id, index, sum}
    end
  end

  def find_guard_and_minute_for_most_times_sleeping({key, value}, {guard_id, index, times}) do
    new_times = Enum.max(value)

    case new_times > times do
      true ->
        new_index = Enum.find_index(value, fn x -> x == new_times end)
        {key, new_index, new_times}

      false ->
        {guard_id, index, times}
    end
  end

  def sort_guard_log(guard_log) do
    Enum.sort(guard_log, fn record1, record2 ->
      case NaiveDateTime.compare(record1.datetime, record2.datetime) do
        :gt -> false
        :lt -> true
      end
    end)
  end

  def fill_in_guard_id([], _, list_with_guard_id), do: list_with_guard_id

  def fill_in_guard_id([head = %Record{guard_id: nil} | tail], guard_id, list_with_guard_id) do
    head_with_guard_id = %Record{head | guard_id: guard_id}
    fill_in_guard_id(tail, guard_id, [head_with_guard_id | list_with_guard_id])
  end

  def fill_in_guard_id([head = %Record{guard_id: id} | tail], _, list_with_guard_id) do
    fill_in_guard_id(tail, id, [head | list_with_guard_id])
  end

  def enum_sleeping_minutes_pr_guard(_guard_log = [], sleeping_minutes), do: sleeping_minutes

  def enum_sleeping_minutes_pr_guard(
        [_head = %Record{action: :begins_shift} | tail],
        sleeping_minutes
      ),
      do: enum_sleeping_minutes_pr_guard(tail, sleeping_minutes)

  def enum_sleeping_minutes_pr_guard(
        [
          %Record{guard_id: id, action: :falls_asleep, datetime: datetime_sleep},
          %Record{guard_id: id, action: :wakes_up, datetime: datetime_up} | tail
        ],
        sleeping_minutes
      ) do
    minutes =
      0..59
      |> Enum.map(fn _ -> 0 end)

    minutes = Map.get(sleeping_minutes, id, minutes)

    new_minutes =
      Range.new(datetime_sleep.minute, datetime_up.minute - 1)
      |> Enum.reduce(minutes, fn x, list -> List.update_at(list, x, fn y -> y + 1 end) end)

    enum_sleeping_minutes_pr_guard(tail, Map.put(sleeping_minutes, id, new_minutes))
  end

  def test_data() do
    """
    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-01 00:05] falls asleep
    [1518-11-01 00:25] wakes up
    [1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-02 00:40] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-03 00:24] falls asleep
    [1518-11-03 00:29] wakes up
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-04 00:36] falls asleep
    [1518-11-04 00:46] wakes up
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-05 00:45] falls asleep
    [1518-11-05 00:55] wakes up
    """
    |> String.trim()
    |> String.split("\n")
  end

  def day4_data() do
    "../../../assets/input4.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n")
  end
end
