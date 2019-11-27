defmodule CCSP.Chapter4.DijkstraNode do
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Chapter 4, titled "Graph Problems"
  """

  @type t :: __MODULE__.t()

  defstruct [:vertex, :distance]

  @spec new(non_neg_integer, non_neg_integer) :: t
  def new(vertex, distance) do
    %T{vertex: vertex, distance: distance}
  end
end

defimpl CCSP.Chapter2.ComparableValue, for: CCSP.Chapter4.DijkstraNode do
  def comparable_value(node) do
    node.distance
  end
end
