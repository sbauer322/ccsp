defmodule CCSP.Chapter2.Maze do
  alias CCSP.Chapter2.MazeLocation
  alias CCSP.Chapter2.Node
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Section 2.2 titled "Maze Solving"
  """

  @type location :: {non_neg_integer, non_neg_integer}
  @type maze_state :: list(list(MazeLocation.t()))
  @opaque t :: __MODULE__.t()

  defstruct state: [], total_rows: 0, total_columns: 0

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

  @spec new(maze_state, non_neg_integer, non_neg_integer) :: t
  def new(state, total_rows, total_columns) do
    %T{state: state, total_rows: total_rows, total_columns: total_columns}
  end

  @spec init(integer, integer, float, location, location) :: t
  def init(rows \\ 9, columns \\ 9, sparseness \\ 0.2, start \\ {0, 0}, goal \\ {9, 9}) do
    randomly_fill_maze(rows, columns, sparseness)
    #    empty_maze(rows, columns)
    |> List.update_at(
      elem(start, 0),
      &List.update_at(&1, elem(start, 1), fn location -> %{location | value: cell("START")} end)
    )
    |> List.update_at(
      elem(goal, 0),
      &List.update_at(&1, elem(goal, 1), fn location -> %{location | value: cell("GOAL")} end)
    )
    |> new(rows + 1, columns + 1)
  end

  @spec get_cell(t, integer, integer) :: MazeLocation.t()
  def get_cell(maze, row, column) do
    maze.state
    |> Enum.at(row)
    |> Enum.at(column)
  end

  @spec empty_maze(integer, integer) :: maze_state
  defp empty_maze(rows, columns) do
    Enum.map(0..rows, fn row ->
      Enum.map(0..columns, fn column -> MazeLocation.new(cell("EMPTY"), row, column) end)
    end)
  end

  @spec randomly_fill_maze(integer, integer, float) :: maze_state
  defp randomly_fill_maze(rows, columns, sparseness) do
    Enum.map(0..rows, fn row ->
      Enum.map(0..columns, fn column ->
        random_cell(row, column, sparseness)
      end)
    end)
  end

  defp random_cell(row, column, value) do
    if :random.uniform() < value do
      MazeLocation.new(cell("BLOCKED"), row, column)
    else
      MazeLocation.new(cell("EMPTY"), row, column)
    end
  end

  @spec successors(t, MazeLocation.t()) :: list(MazeLocation.t())
  def successors(maze, location) do
    row = location.row
    column = location.column
    total_rows = maze.total_rows
    total_columns = maze.total_columns

    south =
      if row + 1 < total_rows and get_cell(maze, row + 1, column).value != cell("BLOCKED") do
        get_cell(maze, row + 1, column)
      end

    north =
      if row - 1 >= 0 and get_cell(maze, row - 1, column).value != cell("BLOCKED") do
        get_cell(maze, row - 1, column)
      end

    east =
      if column + 1 < total_columns and get_cell(maze, row, column + 1).value != cell("BLOCKED") do
        get_cell(maze, row, column + 1)
      end

    west =
      if column - 1 >= 0 and get_cell(maze, row, column - 1).value != cell("BLOCKED") do
        get_cell(maze, row, column - 1)
      end

    Enum.filter([west, east, north, south], &(&1 != nil))
  end

  @spec pretty_print(list(list(String.t()))) :: list(list(String.t()))
  def pretty_print(maze) do
    Enum.map(maze, fn row ->
      Enum.map(row, &(&1.value))
    end)
  end

  @spec mark(t, list(Node.t())) :: list(list(String.t()))
  def mark(maze, path) do
    Enum.reduce(path, maze.state, fn n, acc ->
      List.update_at(
        acc,
        n.row,
        &List.update_at(&1, n.column, fn location -> %{location | value: cell("PATH")} end)
      )
    end)
  end
end
