defmodule CCSP.Chapter6.DataPoint do
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Chapter 6, titled "K-means Clustering"
  """

  @type t :: %T{
          originals: list(float),
          dimensions: list(float)
        }

  defstruct [
    :originals,
    :dimensions
  ]

  @spec new(list(float)) :: t
  def new(initial) do
      %T{originals: initial, dimensions: initial}
  end

  @spec num_dimensions(t) :: non_neg_integer
  def num_dimensions(dp) do
    length(dp.dimensions)
  end

  @spec distance(t, t) :: float
  def distance(dp1, dp2) do
    Enum.zip(dp1.dimensions, dp2.dimensions)
    |> Enum.reduce(0, fn {x, y}, acc ->
      acc + :math.pow(x - y, 2)
    end)
    |> :math.sqrt()
  end

  @spec equal?(t, t) :: bool
  def equal?(dp1, dp2) do
    dp1.dimensions == dp2.dimensions
  end
end

defimpl Inspect, for: CCSP.Chapter6.DataPoint do
  def inspect(dp, _opts) do
    "#{dp.dimensions}"
  end
end

defimpl String.Chars, for: CCSP.Chapter6.DataPoint do
  def to_string(dp) do
    "#{dp.dimensions}"
  end
end