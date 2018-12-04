defmodule AdventTest do
  use ExUnit.Case
  doctest Advent

  test "Day 1 Step 1 - summing up the frequency changes - starting at 0" do
    assert Advent.day1_step1() == 531
  end

  test "Day 1 Step 2 - finding repeated frequency" do
    assert Advent.day1_step2() == 76787
  end

  test "Day 2 Step 1 - checksum for IDs" do
    assert Advent.day2_step1() == 5952
  end

  test "Day 2 Step 2 - finding common chars for the correct IDs" do
    assert Advent.day2_step2() == ["krdmtuqjgwfoevnaboxglzjph"]
  end

  test "Day 3 Step 1 - finding number of overlapping areas" do
    assert Advent.Fabric.Plan.find_number_of_overlap() == 116_489
  end

  test "Day 2 Step 2 - finding non-overlapping claim ID" do
    assert Advent.Fabric.Plan.find_nonoverlapping() == 1260
  end
end
