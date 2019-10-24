defmodule CCSP.Chapter2.Stack do
  alias __MODULE__, as: T

  @opaque t :: __MODULE__.t()

  defstruct list: []

  @spec new(list(any)) :: t
  def new(list \\ []) do
    %T{list: list}
  end

  def pop(%T{list: []}) do
    {nil, %T{}}
  end

  def pop(%T{list: [head]}) do
    {head, %T{list: [head]}}
  end

  def pop(%T{list: [head | rest]}) do
    {head, rest}
  end

  def push(list, element) do
    new([element | list])
  end

  def empty?(list) do
    list == %T{}
  end
end
