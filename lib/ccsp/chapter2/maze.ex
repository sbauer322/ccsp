defmodule CCSP.Chapter2.Maze do
  alias CCSP.Chapter2.MazeLocation
  alias CCSP.Chapter2.Node
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Section 2.2 titled "Maze Solving"

  TODO: The constant use of `get_cell` causes heavy use of `List.slice` internally and does not scale well.
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
    |> Enum.at(row, [])
    |> Enum.at(column, nil)
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

  defp specific_maze() do
    [
      ["S", " ", " ", " ", " ", "X", " ", " ", " ", " "],
      [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
      [" ", " ", " ", "X", " ", "X", "X", " ", " ", " "],
      [" ", "X", " ", " ", " ", " ", "X", " ", " ", " "],
      ["X", " ", " ", " ", " ", " ", "X", " ", " ", "X"],
      [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
      [" ", "X", " ", " ", "X", " ", "X", " ", " ", "X"],
      [" ", " ", "X", "X", " ", " ", "X", " ", " ", " "],
      [" ", " ", " ", " ", " ", " ", " ", " ", "X", " "],
      [" ", " ", " ", " ", " ", " ", " ", " ", "X", "G"]
    ]
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {column, column_index} ->
        MazeLocation.new(column, row_index, column_index)
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

    south = fn ->
      neighbor_cell = get_cell(maze, row + 1, column)

      if row + 1 < total_rows and neighbor_cell.value != cell("BLOCKED") do
        neighbor_cell
      end
    end

    north = fn ->
      neighbor_cell = get_cell(maze, row - 1, column)

      if row - 1 >= 0 and neighbor_cell.value != cell("BLOCKED") do
        neighbor_cell
      end
    end

    east = fn ->
      neighbor_cell = get_cell(maze, row, column + 1)

      if column + 1 < total_columns and neighbor_cell.value != cell("BLOCKED") do
        neighbor_cell
      end
    end

    west = fn ->
      neighbor_cell = get_cell(maze, row, column - 1)

      if column - 1 >= 0 and neighbor_cell.value != cell("BLOCKED") do
        neighbor_cell
      end
    end

    Enum.filter([west.(), east.(), north.(), south.()], &(&1 != nil))
  end

  @spec manhattan_distance(MazeLocation.t()) :: (MazeLocation.t() -> non_neg_integer)
  def manhattan_distance(goal) do
    fn m1 ->
      x_distance = abs(m1.column - goal.column)
      y_distance = abs(m1.row - goal.row)
      x_distance + y_distance
    end
  end

  @spec pretty_print(list(list(maze_state))) :: :ok
  def pretty_print(maze_state) do
    Enum.each(maze_state, fn row ->
      Enum.each(row, &IO.write(" #{&1.value} "))
      IO.puts("")
    end)
  end

  @spec mark(t, list(Node.t()), MazeLocation.t(), MazeLocation.t()) :: list(list(maze_state))
  def mark(maze, path, start, goal) do
    Enum.reduce(path, maze.state, fn n, acc ->
      List.update_at(
        acc,
        n.row,
        &List.update_at(&1, n.column, fn location -> %{location | value: cell("PATH")} end)
      )
    end)
    |> List.update_at(
      start.row,
      &List.update_at(&1, start.column, fn location -> %{location | value: cell("START")} end)
    )
    |> List.update_at(
      goal.row,
      &List.update_at(&1, goal.column, fn location -> %{location | value: cell("GOAL")} end)
    )
  end
end
