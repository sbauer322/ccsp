defmodule CCSP.Chapter2.PriorityQueue do
  alias CCSP.Chapter2.Node
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Section 2.2 titled "Maze Solving"

  List based priority queue using Node structs.

  For the sake of effeciency, we lazily order the list... in particular, only when pop is called.
  """

  @opaque t :: __MODULE__.t()

  defstruct list: []

  @spec new(list(Node.t())) :: t
  def new(list \\ []) do
    %T{list: list}
  end

  @spec pop(t) :: {Node.t(), t}
  def pop(queue) do
    cond do
      empty?(queue) ->
        {nil, queue}

      length(queue.list) == 1 ->
        {hd(queue.list), new()}

      length(queue.list) > 1 ->
        ordered = order(queue.list)
        {hd(ordered), new(tl(ordered))}
    end
  end

  @spec push(t, Node.t()) :: t
  def push(queue, element) do
    %T{list: [element | queue.list]}
  end

  @spec empty?(t) :: boolean
  def empty?(queue) do
    Enum.empty?(queue.list)
  end

  @spec order(list(Node.t())) :: list(Node.t())
  def order(list) do
    list
    |> Enum.group_by(fn element -> element.heuristic end)
    |> Map.to_list()
    |> Enum.sort(fn {priority, _}, {other_priority, _} -> priority >= other_priority end)
    |> Enum.flat_map(fn {_priority, elements} -> elements end)
  end
end
