defmodule CCSP.Chapter2.PriorityQueue do
  alias CCSP.Chapter2.ComparableValue
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Section 2.2 titled "Maze Solving"

  List based priority queue using Node structs. We rely on the heuristic field from the node to determine priority. This can be made more generic in the future, if needed.

  For the sake of efficiency, we lazily order the list... in particular, only when pop is called.
  """

  @opaque t(term) :: __MODULE__.t(term)

  defstruct list: []

  @spec new(list(ComparableValue.t())) :: t(ComparableValue.t())
  def new(list \\ []) do
    %T{list: list}
  end

  @spec pop(t(ComparableValue.t())) :: {ComparableValue.t(), t(ComparableValue.t())}
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

  @spec push(t(ComparableValue.t()), ComparableValue.t()) :: t(ComparableValue.t())
  def push(queue, element) do
    %T{list: [element | queue.list]}
  end

  @spec empty?(t(ComparableValue.t())) :: boolean
  def empty?(queue) do
    Enum.empty?(queue.list)
  end

  @spec order(list(ComparableValue.t())) :: list(ComparableValue.t())
  def order(list) do
    list
    |> Enum.group_by(fn element -> ComparableValue.comparable_value(element) end)
    |> Map.to_list()
    |> Enum.sort(fn {priority, _}, {other_priority, _} -> priority < other_priority end)
    |> Enum.flat_map(fn {_priority, elements} -> elements end)
  end
end
