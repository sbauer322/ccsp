defmodule CCSP.Chapter2.Start do
  alias CCSP.Chapter2.Maze
  alias CCSP.Chapter2.GenericSearch

  @moduledoc """
  Convenience module for setting up and running more elaborate sections.
  """

  #  def run_maze_generation() do
  #    maze = Maze.init(9, 9, 0.2, {0, 0}, {9, 9})
  #    Maze.pretty_print(maze.state)
  #  end

  def run_dfs_maze_solving() do
    rows = 9
    columns = 9
    maze = Maze.init(rows, columns, 0.2, {0, 0}, {rows, columns})
    start = Maze.get_cell(maze, 0, 0)
    goal = Maze.get_cell(maze, rows, columns)
    goal_fn = fn location -> "G" == location.value end

    path =
      GenericSearch.depth_first_search(maze, start, goal_fn, &Maze.successors/2)
      |> GenericSearch.node_to_path()

    Maze.mark(maze, path, start, goal)
    |> Maze.pretty_print()
  end

  def run_bfs_maze_solving() do
    rows = 9
    columns = 9
    maze = Maze.init(rows, columns, 0.2, {0, 0}, {rows, columns})
    start = Maze.get_cell(maze, 0, 0)
    goal = Maze.get_cell(maze, rows, columns)
    goal_fn = fn location -> "G" == location.value end

    path =
      GenericSearch.breadth_first_search(maze, start, goal_fn, &Maze.successors/2)
      |> GenericSearch.node_to_path()

    Maze.mark(maze, path, start, goal)
    |> Maze.pretty_print()
  end

  def run_astar_maze_solving do
    rows = 9
    columns = 9
    maze = Maze.init(rows, columns, 0.2, {0, 0}, {rows, columns})
    start = Maze.get_cell(maze, 0, 0)
    goal = Maze.get_cell(maze, rows, columns)
    goal_fn = fn location -> "G" == location.value end

    path =
      GenericSearch.astar_search(
        maze,
        start,
        goal_fn,
        &Maze.successors/2,
        Maze.manhattan_distance(goal)
      )
      |> GenericSearch.node_to_path()

    Maze.mark(maze, path, start, goal)
    |> Maze.pretty_print()
  end
end
