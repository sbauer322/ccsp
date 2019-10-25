defmodule CCSP.Start do
  alias CCSP.Chapter2.Maze
  alias CCSP.Chapter2.GenericSearch

  @moduledoc """
  Convenience module to for setting up and running more elaborate sections.
  """

  def run_maze_solving() do
    rows = 9
    columns = 9
    maze = Maze.init(rows, columns, 0.2, {0, 0}, {rows, columns})
    initial = Maze.get_cell(maze, 0, 0)
    goal = Maze.get_cell(maze, rows, columns)

    path =
      GenericSearch.depth_first_search(maze, initial, goal, &Maze.successors/2)
      |> GenericSearch.node_to_path()

    Maze.mark(maze, path)
    |> Maze.pretty_print()
  end
end
