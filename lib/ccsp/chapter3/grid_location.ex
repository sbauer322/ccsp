defmodule CCSP.Chapter3.GridLocation do
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Section 3.4 titled "Word Search".

  Should be very similar to the MazeLocation from Chapter 2.
  """

  @type t :: __MODULE__.t()

  defstruct row: nil, column: nil

  @spec new(non_neg_integer, non_neg_integer) :: t
  def new(row, column) do
    %T{row: row, column: column}
  end
end
