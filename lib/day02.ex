defmodule Aoc2023.Day02.Part1 do
  @max_red 12
  @max_green 13
  @max_blue 14

  def solve(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&process_line/1)
    |> Enum.reduce(0, &sum_possible_games/2)
  end

  def process_line(line) do
    ["Game " <> id, sets] = 
      line
      |> String.split(": ")

    processed_sets =
      sets
      |> String.split(";")
      |> Enum.map(&process_set/1)
      |> Enum.reduce(true, &is_possible_play?/2)

    { String.to_integer(id), processed_sets }
  end

  def process_set(set) do
    set
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(%{}, &process_pair/2)
  end

  def process_pair(pair, set_record) do
    [value, key] = String.split(pair, " ")
    Map.put(set_record, key, String.to_integer(value))
  end

  def is_possible_play?(play, acc) do
    red_count = Map.get(play, "red", 0)
    green_count = Map.get(play, "green", 0)
    blue_count = Map.get(play, "blue", 0)

    is_possible = (
      red_count <= @max_red
      and green_count <= @max_green
      and blue_count <= @max_blue
    )

    if not acc do
      acc
    else
      is_possible
    end
  end

  def sum_possible_games({id, true}, acc), do: acc + id
  def sum_possible_games({_id, false}, acc), do: acc
end

defmodule Aoc2023.Day02.Part2 do
  def solve(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&process_line/1)
    |> Enum.map(fn {a, b, c} -> a * b * c end)
    |> Enum.sum
  end

  def process_line(line) do
    [_, sets] = 
      line
      |> String.split(": ")

    sets
    |> String.split(";")
    |> Enum.map(&process_set/1)
    |> Enum.reduce({1, 1, 1}, &get_max_number/2)
  end

  def process_set(set) do
    set
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(%{}, &process_pair/2)
  end

  def process_pair(pair, set_record) do
    [value, key] = String.split(pair, " ")
    Map.put(set_record, key, String.to_integer(value))
  end

  def get_max_number(pair, acc) do
    red_count = Map.get(pair, "red", 1)
    green_count = Map.get(pair, "green", 1)
    blue_count = Map.get(pair, "blue", 1)

    {
      max(red_count, elem(acc,0)),
      max(green_count, elem(acc,1)),
      max(blue_count, elem(acc,2))
    }
  end
end

defmodule Mix.Tasks.Day02 do
  use Mix.Task
  alias Aoc2023.Day02.Part1
  alias Aoc2023.Day02.Part2

  def run(_) do
    {:ok, input} = File.read("data/day02.txt")

    IO.puts("Part 1:")
    IO.inspect Part1.solve(input)
    IO.puts("")
    IO.puts("Part 2:")
    IO.inspect Part2.solve(input)
  end
end
