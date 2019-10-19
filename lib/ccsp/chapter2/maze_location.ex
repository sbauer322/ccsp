defmodule CCSP.Chapter2.MazeLocation do
  alias __MODULE__, as: T

  @opaque t :: __MODULE__.t()

  defstruct value: nil, row: nil, column: nil

  def new(value, row, column) do
    %T{value: value, row: row, column: column}
  end
end
