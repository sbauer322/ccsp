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
    # We leverage the `with`s and how they short circuit to progressively build up the `locations`.
    locations = acc

    locations =
      with true <- col + length <= width,
           locations <- left_to_right(columns, row, locations),
           true <- row + length <= height,
           locations <- diagonal_towards_bottom_right(rows, col, row, locations) do
        locations
      else
        _ -> locations
      end

    locations =
      with true <- row + length <= height,
           locations <- top_to_bottom(rows, col, locations),
           true <- col - length >= 0,
           locations <- diagonal_towards_bottom_left(rows, col, row, locations) do
        locations
      else
        _ -> locations
      end

    locations
  end

  defp left_to_right(columns, row, locations) do
    Enum.map(columns, fn c ->
      GridLocation.new(row, c)
    end)
    |> (&[&1 | locations]).()
  end

  defp diagonal_towards_bottom_right(rows, col, row, locations) do
    Enum.map(rows, fn r ->
      GridLocation.new(r, col + (r - row))
    end)
    |> (&[&1 | locations]).()
  end

  defp top_to_bottom(rows, col, locations) do
    Enum.map(rows, fn r ->
      GridLocation.new(r, col)
    end)
    |> (&[&1 | locations]).()
  end

  defp diagonal_towards_bottom_left(rows, col, row, locations) do
    Enum.map(rows, fn r ->
      GridLocation.new(r, col - (r - row))
    end)
    |> (&[&1 | locations]).()
  end

  @spec display_grid(grid) :: :ok
  def display_grid(grid) do
    Enum.each(grid, fn row ->
      Enum.each(row, &IO.write(" #{&1} "))
      IO.puts("")
    end)
  end
end
