defmodule CCSP.Chapter2.Node do
  alias __MODULE__, as: T

  @opaque t :: __MODULE__.t()

  defstruct state: nil, parent: nil, cost: 0.0, heuristic: 0.0

  @spec new(any, t, float, float) :: t
  def new(state, parent, cost \\ 0.0, heuristic \\ 0.0) do
    %T{state: state, parent: parent, cost: cost, heuristic: heuristic}
  end

  @spec lt(t, t) :: boolean
  def lt(left, right) do
    left.cost + left.heuristic < right.cost + right.heuristic
  end
end
