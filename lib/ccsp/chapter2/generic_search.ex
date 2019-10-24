defmodule CCSP.Chapter2.GenericSearch do
  alias CCSP.Chapter2.Stack
  alias CCSP.Chapter2.Node

  @moduledoc """
  Corresponds to CCSP in Python, Section 2.2 titled "Maze Solving"
  """

  @spec linear_contains?(list(any), any) :: boolean
  def linear_contains?(elements, key) do
    Enum.any?(elements, &(&1 == key))
  end

  @doc """
  Assumes elements are already sorted.
  """
  @spec binary_contains?(list(any), any) :: boolean
  def binary_contains?(sorted_elements, key) do
    binary_search(sorted_elements, key, 0, length(sorted_elements) - 1)
  end

  @spec binary_search(list(any), any, non_neg_integer, non_neg_integer) :: boolean
  defp binary_search(elements, key, low, high) when low <= high do
    mid = div(low + high, 2)
    mid_elements = Enum.at(elements, mid)

    cond do
      mid_elements < key -> binary_search(elements, key, mid + 1, high)
      mid_elements > key -> binary_search(elements, key, low, mid - 1)
      true -> true
    end
  end

  def depth_first_search(maze, initial, goal, successors_fn) do
    frontier =
      Stack.new()
      |> Stack.push(Node.new(initial, nil))

    explored =
      MapSet.new()
      |> MapSet.put(initial)

    dfs(maze, frontier, explored, successors_fn)
  end

  defp dfs(maze, frontier, explored, successors_fn) do
    if Stack.empty?(frontier) == false do
      {current_node, frontier} = Stack.pop(frontier)
      current_state = current_node.state

      if current_state.value == "G" do
        current_node
      else
        {frontier, explored} =
          Enum.reduce(successors_fn.(maze, current_state), {frontier, explored}, fn child,
                                                                                    {frontier,
                                                                                     explored} ->
            if Enum.member?(explored, child) == true do
              {frontier, explored}
            else
              frontier = Stack.push(frontier, Node.new(child, current_node))
              explored = MapSet.put(explored, child)
              {frontier, explored}
            end
          end)

        dfs(maze, frontier, explored, successors_fn)
      end
    end
  end

  #  defp dfs(maze, frontier, explored, successors_fn) when frontier == [] do
  #    IO.puts("dfs 3")
  #    nil
  #  end

  def node_to_path(n) when n == nil do
    []
  end

  def node_to_path(n) when n != nil do
    path = [n.state]
    node_to_path(n, path)
  end

  defp node_to_path(n, path) do
    cond do
      n.parent == nil ->
        path

      n.parent != nil ->
        n = n.parent
        node_to_path(n, [n.state | path])
    end
  end
end
