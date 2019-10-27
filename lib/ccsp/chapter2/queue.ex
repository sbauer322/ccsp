defmodule CCSP.Chapter2.Queue do
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Section 2.2 titled "Maze Solving"
  """

  @opaque t :: __MODULE__.t()

  defstruct list: []

  @spec new(list(any)) :: t
  def new(queue \\ []) do
    %T{list: :queue.from_list(queue)}
  end

  @spec pop(t) :: {any, t}
  def pop(queue) do
    if empty?(queue) do
      {nil, queue}
    else
      {{:value, x}, q} = :queue.out(queue.list)
      {x, %T{list: q}}
    end
  end

  @spec push(t, any) :: t
  def push(queue, element) do
    %T{list: :queue.in(element, queue.list)}
  end

  @spec empty?(t) :: boolean
  def empty?(stack) do
    :queue.is_empty(stack.list)
  end
end
