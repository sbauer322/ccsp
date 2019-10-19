defmodule CCSP.Chapter2.Maze do
  alias CCSP.Chapter2.MazeLocation

  @type location :: {non_neg_integer, non_neg_integer}
  @type maze :: list(list(MazeLocation.t()))

  @spec cell(String.t()) :: String.t()
  def cell(str) do
    case str do
      "EMPTY" -> " "
      "BLOCKED" -> "X"
      "START" -> "S"
      "GOAL" -> "G"
      "PATH" -> "*"
    end
  end

  @spec init(integer, integer, float, location, location) :: any
  def init(rows \\ 9, columns \\ 9, sparseness \\ 0.2, start \\ {0, 0}, goal \\ {9, 9}) do
    randomly_fill_maze(rows, columns, sparseness)
    |> List.update_at(
      elem(start, 0),
      &List.update_at(&1, elem(start, 1), fn location -> %{location | value: cell("START")} end)
    )
    |> List.update_at(
      elem(goal, 0),
      &List.update_at(&1, elem(goal, 1), fn location -> %{location | value: cell("GOAL")} end)
    )
  end

  @spec get_cell(maze, integer, integer) :: String.t()
  def get_cell(maze, row, column) do
    maze
    |> Enum.at(row)
    |> Enum.at(column)
  end

  @spec empty_maze(integer, integer) :: maze
  defp empty_maze(rows, columns) do
    Enum.map(0..rows, fn row ->
      Enum.map(0..columns, fn column -> MazeLocation.new(cell("EMPTY"), row, column) end)
    end)
  end

  @spec randomly_fill_maze(integer, integer, float) :: maze
  defp randomly_fill_maze(rows, columns, sparseness) do
    Enum.map(0..rows, fn row ->
      Enum.map(0..columns, fn column ->
        if :random.uniform() < sparseness do
          MazeLocation.new(cell("BLOCKED"), row, column)
        else
          MazeLocation.new(cell("EMPTY"), row, column)
        end
      end)
    end)
  end

  @spec successors(maze, location, integer, integer) :: list(any)
  def successors(maze, {row, column}, total_rows, total_columns) do
    south =
      if row + 1 < total_rows and get_cell(maze, row + 1, column) != cell("BLOCKED") do
        {row + 1, column}
      end

    north =
      if row - 1 >= 0 and get_cell(maze, row - 1, column) != cell("BLOCKED") do
        {row - 1, column}
      end

    east =
      if column + 1 < total_columns and get_cell(maze, row, column + 1) != cell("BLOCKED") do
        {row, column + 1}
      end

    west =
      if column - 1 >= 0 and get_cell(maze, row, column - 1) != cell("BLOCKED") do
        {row, column - 1}
      end

    Enum.filter([south, north, east, west], &(&1 != nil))
  end

  @spec pretty_print(maze) :: list(list(String.t()))
  def pretty_print(maze) do
    Enum.map(maze, fn row ->
      Enum.map(row, & &1.value)
    end)
  end
end
