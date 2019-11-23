defmodule CCSP.Chapter2.MazeLocation do
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Section 2.2 titled "Maze Solving"
  """

  @type t :: __MODULE__.t()

  defstruct value: nil, row: nil, column: nil

  @spec new(String.t(), non_neg_integer, non_neg_integer) :: t
  def new(value, row, column) do
    %T{value: value, row: row, column: column}
  end
end
