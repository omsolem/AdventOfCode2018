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
end
