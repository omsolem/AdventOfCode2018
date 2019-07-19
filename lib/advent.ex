defmodule Advent do
  def day1_step1() do
    Advent.Frequency.Finder.calculate_total()
  end

  def day1_step2() do
    Advent.Frequency.Finder.first_frequency_twice()
  end

  def day2_step1() do
    Advent.BoxID.file_checksum()
  end

  def day2_step2() do
    Advent.BoxID.find_prototype_fabric()
  end

  def day3_step1() do
    Advent.Fabric.Plan.find_number_of_overlap()
  end

  def day3_step2() do
    Advent.Fabric.Plan.find_nonoverlapping()
  end

  def day4_step1() do
    {guard_id, minute, _total_sleeping} = Advent.Guard.Log.strategy1()
    "Guard #{guard_id} sleeps very often at 00:#{minute} - the answer is #{guard_id * minute}"
  end

  def day4_step2() do
    {guard_id, minute, times} = Advent.Guard.Log.strategy2()
    "Guard #{guard_id} sleeps #{times} times at 00:#{minute} - the answer is #{guard_id * minute}"
  end
end
