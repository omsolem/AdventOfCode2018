defmodule Advent.Guard.Record do
  import NimbleParsec

  defstruct guard_id: Integer,
            datetime: DateTime,
            action: Atom

  defparsecp(
    :entry,
    ignore(string("["))
    |> integer(4)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string(" "))
    |> integer(2)
    |> ignore(string(":"))
    |> integer(2)
    |> ignore(string("] "))
    |> choice([
      ignore(string("Guard #"))
      |> replace(:begins_shift)
      |> integer(min: 1, max: 4)
      |> ignore(string(" begins shift")),
      ignore(string("falls asleep"))
      |> replace(:falls_asleep),
      ignore(string("wakes up"))
      |> replace(:wakes_up)
    ]),
    debug: false
  )

  def new(log_entry_string) do
    entry(log_entry_string)
    |> new_struct()
  end

  def new_struct({:ok, [year, month, day, hour, minute, action], "", _, _, _}) do
    {:ok, datetime} = NaiveDateTime.new(year, month, day, hour, minute, 0)

    %Advent.Guard.Record{
      guard_id: nil,
      datetime: datetime,
      action: action
    }
  end

  def new_struct({:ok, [year, month, day, hour, minute, :begins_shift, guard_id], "", _, _, _}) do
    {:ok, datetime} = NaiveDateTime.new(year, month, day, hour, minute, 0)

    %Advent.Guard.Record{
      guard_id: guard_id,
      datetime: datetime,
      action: :begins_shift
    }
  end
end
