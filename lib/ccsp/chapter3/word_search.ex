defmodule CCSP.Chapter3.WordSearch do
  alias CCSP.Chapter3.GridLocation
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Section 3.4 titled "Word Search".
  """

  @type t :: __MODULE__.t()
  @type grid :: list(list(String.t()))
  @type row :: non_neg_integer
  @type column :: non_neg_integer

  @alphabet Enum.to_list(?A..?Z)

  defstruct value: nil, row: nil, column: nil

  @spec generate_grid(row, column) :: grid
  def generate_grid(rows, columns) do
    Enum.map(0..(rows - 1), fn _ ->
      Enum.map(0..(columns - 1), fn _ ->
        random_string(1)
      end)
    end)
  end

  @spec random_string(non_neg_integer) :: list(String.t())
  def random_string(length) do
    Stream.repeatedly(fn ->
      Enum.random(@alphabet)
    end)
    |> Enum.take(length)
  end

  @spec generate_domain(String.t(), grid) :: list(list(GridLocation.t()))
  def generate_domain(word, grid) do
    height = length(grid) - 1
    width = length(Enum.at(grid, 0)) - 1
    length = String.length(word)

    domain =
      Enum.reduce(0..height, [], fn row, acc ->
        Enum.reduce(0..width, acc, fn col, acc ->
          columns = col..(col + length)
          rows = row..(row + length)
          potential_locations(acc, row, col, rows, columns, width, height, length)
        end)
      end)

    Enum.reverse(domain)
  end

  @spec potential_locations(
          list,
          non_neg_integer,
          non_neg_integer,
          Range.t(),
          Range.t(),
          non_neg_integer,
          non_neg_integer,
          non_neg_integer
        ) :: list(list(GridLocation.t()))
  def potential_locations(acc, row, col, rows, columns, width, height, length) do
    locations = acc

    locations =
      if col + length <= width do
        # left to right
        left_to_right =
          Enum.map(columns, fn c ->
            GridLocation.new(row, c)
          end)
          |> (&[&1 | locations]).()

        # diagonal towards bottom right
        if row + length <= height do
          Enum.map(rows, fn r ->
            GridLocation.new(r, col + (r - row))
          end)
          |> (&[&1 | left_to_right]).()
        else
          left_to_right
        end
      else
        locations
      end


      if row + length <= height do
        # top to bottom
        top_to_bottom =
          Enum.map(rows, fn r ->
            GridLocation.new(r, col)
          end)
          |> (&[&1 | locations]).()

        if col - length >= 0 do
          Enum.map(rows, fn r ->
            GridLocation.new(r, col - (r - row))
          end)
          |> (&[&1 | top_to_bottom]).()
        else
          top_to_bottom
        end
      else
        locations
      end
  end

  @spec display_grid(grid) :: :ok
  def display_grid(grid) do
    Enum.each(grid, fn row ->
      Enum.each(row, &IO.write(" #{&1} "))
      IO.puts("")
    end)
  end
end
