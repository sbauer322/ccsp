defmodule CCSP.Chapter4.Edge do
  alias __MODULE__, as: T

  @moduledoc """
    Corresponds to CCSP in Python, Chapter 4, titled "Graph problems"
  """

  defstruct [:u, :v]

  @type t :: %T{
          u: integer,
          v: integer
        }

  def new(u, v) do
    %T{u: u, v: v}
  end

  @spec reversed(t) :: t
  def reversed(edge) do
    %T{u: edge.v, v: edge.u}
  end
end

defimpl Inspect, for: CCSP.Chapter4.Edge do
  def inspect(edge, _opts) do
    "#{edge.u} -> #{edge.v}"
  end
end

defimpl String.Chars, for: CCSP.Chapter4.Edge do
  def to_string(edge) do
    "#{edge.u} -> #{edge.v}"
  end
end
