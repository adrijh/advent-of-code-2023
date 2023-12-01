# Unicode
# . 46
# 0 48
# 9 57


defmodule Aoc2023.Day03.Part1 do
  def solve(input) do
    matrix = input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&to_charlist/1)

    input_positions = matrix
    |> Enum.with_index
    |> Enum.map(&get_relevant_position/1)
    |> Enum.flat_map(& &1)
    |> Enum.reject(&is_nil/1)
    
    number_groups = input_positions
    |> Enum.filter(fn {_, _, t} -> t == "d" end)
    |> Enum.map(fn {x, y, _} -> {x, y} end)
    |> group_digits

    valid_digit_positions = input_positions
    |> Enum.filter(fn {_, _, t} -> t == "s" or t == "g" end)
    |> Enum.map(&get_valid_positions/1)
    |> Enum.flat_map(& &1)

    number_groups
    |> Enum.filter(&is_valid_number_group?(&1, valid_digit_positions))
    |> Enum.map(&get_number_from_group(&1, matrix))
    |> Enum.sum
  end

  def get_number_from_group(group, matrix) do
    group
    |> Enum.map(fn {row, col} ->
      [Enum.at(Enum.at(matrix, row), col)]
    end)
    |> List.flatten
    |> List.to_string()
    |> String.to_integer()
  end

  def is_valid_number_group?(number_group, valid_positions) do
    number_group
    |> Enum.any?(
      fn position ->
      Enum.member?(valid_positions, position) end
    )
  end

  def group_digits([], _, [], acc), do: acc
  def group_digits([], _, number_pos, acc), do: [Enum.reverse(number_pos) | acc ]
  def group_digits([h | t], prev_digit \\ nil, number_pos \\ [], acc \\ []) do
    if is_same_number?(h, prev_digit) do
       group_digits(t, h, [h | number_pos], acc)
    else
      acc = [Enum.reverse(number_pos) | acc]
      group_digits(t, h, [h], acc)
    end
  end

  defp is_same_number?(_, nil), do: true
  defp is_same_number?({x, y}, {x_p, y_p}) do
    x == x_p and y == y_p + 1
  end

  def get_relevant_position({line, line_number}) do
    line
    |> Enum.with_index
    |> Enum.map(&create_position_vector(&1, line_number))
  end

  def create_position_vector({char, char_index}, line_number) do
    cond do
      char >= 48 and char <= 57 -> {line_number, char_index, "d"}
      char == 42 -> {line_number, char_index, "g"}
      char != 46 -> {line_number, char_index, "s"}
      true -> nil
    end
  end

  def is_not_digit?({char, _char_index}) do
    if char >= 48 and char <= 57 do
      1
    end
  end

  def get_valid_positions(symbol_position) do
    x_coord = elem(symbol_position, 0)
    y_coord = elem(symbol_position, 1)

    for x <- (x_coord - 1)..(x_coord + 1),
      y <- (y_coord - 1)..(y_coord + 1),
      not (x == x_coord and y == y_coord), 
    do: {x, y}
  end

end

defmodule Aoc2023.Day03.Part2 do
  alias Aoc2023.Day03.Part1

  def solve(input) do
    matrix = input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&to_charlist/1)

    input_positions = matrix
    |> Enum.with_index
    |> Enum.map(&Part1.get_relevant_position/1)
    |> Enum.flat_map(& &1)
    |> Enum.reject(&is_nil/1)

    number_groups = input_positions
    |> Enum.filter(fn {_, _, t} -> t == "d" end)
    |> Enum.map(fn {x, y, _} -> {x, y} end)
    |> Part1.group_digits

    valid_digit_positions = input_positions
    |> Enum.filter(fn {_, _, t} -> t == "g" end)
    |> Enum.map(&Part1.get_valid_positions/1)
    |> Enum.filter(&number_groups_enabled_count(&1, number_groups) == 2)
    # |> Enum.flat_map(& &1)

    # number_groups
    # |> Enum.filter(&Part1.is_valid_number_group?(&1, valid_digit_positions))
    # |> Enum.map(&Part1.get_number_from_group(&1, matrix))
    # |> length

    valid_digit_positions
  end

  defp number_groups_enabled_count(valid_positions, number_groups) do
    number_groups
    |> Enum.count(fn group ->
      Enum.any?(group, fn position ->
        Enum.member?(valid_positions, position)
      end)
    end)
  end
end

defmodule Mix.Tasks.Day03 do
  use Mix.Task
  alias Aoc2023.Day03.Part1
  alias Aoc2023.Day03.Part2

  def run(_) do
    {:ok, input} = File.read("data/day03.txt")

    # IO.puts("Part 1:")
    # IO.inspect Part1.solve(input)
    # IO.puts("")
    IO.puts("Part 2:")
    IO.inspect Part2.solve(input)
  end
end
