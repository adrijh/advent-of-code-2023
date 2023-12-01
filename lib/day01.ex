defmodule Aoc2023.Day01.Part1 do
  def solve(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&remove_characters/1)
    |> Enum.map(&keep_first_and_last/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
  end

  def remove_characters(line) do
    line
    |> String.replace(~r/[^\d]/, "")
  end

  def keep_first_and_last(line) do
    "#{String.first(line)}#{String.last(line)}"
  end

end

defmodule Aoc2023.Day01.Part2 do
  @spelled_digits %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
  }

  def solve(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&replace_spelled_digits/1)
    |> Enum.map(&remove_characters/1)
    |> Enum.map(&keep_first_and_last/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
  end

  def replace_spelled_digits(line) do
    @spelled_digits
    |> Enum.reduce(
      line,
      fn {spelled, digit}, processed ->
        replace_digits_impl(processed, spelled, digit)
      end
    )
  end

  def replace_digits_impl(line, spelled_digit, digit) do
    first_letter = String.first(spelled_digit)
    last_letter = String.last(spelled_digit)
    digit_repl = "#{first_letter}#{digit}#{last_letter}"

    String.replace(
      line,
      spelled_digit,
      digit_repl)
  end

  def remove_characters(line) do
    line
    |> String.replace(~r/[^\d]/, "")
  end

  def keep_first_and_last(line) do
    "#{String.first(line)}#{String.last(line)}"
  end
end

defmodule Mix.Tasks.Day01 do
  use Mix.Task
  alias Aoc2023.Day01.Part1
  alias Aoc2023.Day01.Part2

  def run(_) do
    {:ok, input} = File.read("data/day01.txt")

    IO.puts("Part 1:")
    IO.inspect Part1.solve(input)
    IO.puts("")
    IO.puts("Part 2:")
    IO.inspect Part2.solve(input)
  end
end
