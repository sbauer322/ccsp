defmodule CCSP.Chapter4.WeightedEdge do
  alias __MODULE__, as: T

  @moduledoc """
    Corresponds to CCSP in Python, Chapter 4, titled "Graph problems"
  """

  defstruct [:u, :v, :weight]

  @type t :: %T{
               u: integer,
               v: integer,
               weight: integer
             }

  def new(u, v, weight) do
    %T{u: u, v: v, weight: weight}
  end

  @spec reversed(t) :: t
  def reversed(edge) do
    %T{u: edge.v, v: edge.u, weight: edge.weight}
  end
end

defimpl CCSP.Chapter2.ComparableValue, for: CCSP.Chapter4.WeightedEdge do
  def comparable_value(edge) do
    edge.weight
  end
end

defimpl Inspect, for: CCSP.Chapter4.WeightedEdge do
  def inspect(edge, _opts) do
    "#{edge.u}, #{edge.weight} -> #{edge.v}"
  end
end

defimpl String.Chars, for: CCSP.Chapter4.WeightedEdge do
  def to_string(edge) do
    "#{edge.u}, #{edge.weight} -> #{edge.v}"
  end
end