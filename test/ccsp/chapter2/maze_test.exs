defmodule CCSP.Chapter2.MazeTest do
  use ExUnitProperties
  use ExUnit.Case
  alias CCSP.Chapter2.Maze
  @moduledoc false

  test "check expected properties of generated maze" do
    maze = Maze.init(9, 9, 0.2, {0, 0}, {9, 9})

    # 0-indexed, ten total
    assert 10 == length(maze.state)

    Enum.each(maze.state, fn row ->
      assert 10 == length(row)
    end)

    assert "S" == Maze.get_cell(maze, 0, 0).value
    assert "G" == Maze.get_cell(maze, 9, 9).value
  end
end
