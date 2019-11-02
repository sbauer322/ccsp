defmodule CCSP.Chapter2.GenericSearch do
  alias CCSP.Chapter2.PriorityQueue
  alias CCSP.Chapter2.Stack
  alias CCSP.Chapter2.Queue
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

  @spec depth_first_search(
          a,
          b,
          (b -> boolean),
          (a, b -> list(b))
        ) :: Node.t()
        when a: var, b: var
  def depth_first_search(maze, initial, goal_fn, successors_fn) do
    frontier =
      Stack.new()
      |> Stack.push(Node.new(initial, nil))

    explored =
      MapSet.new()
      |> MapSet.put(initial)

    dfs(maze, frontier, explored, goal_fn, successors_fn)
  end

  @spec dfs(
          a,
          Stack.t(),
          MapSet.t(),
          (b -> boolean),
          (a, b -> list(b))
        ) :: Node.t()
        when a: var, b: var
  defp dfs(maze, frontier, explored, goal_fn, successors_fn) do
    if Stack.empty?(frontier) == false do
      {current_node, frontier} = Stack.pop(frontier)
      current_state = current_node.state

      if goal_fn.(current_state) do
        current_node
      else
        {frontier, explored} =
          Enum.reduce(
            successors_fn.(maze, current_state),
            {frontier, explored},
            fn child, {frontier, explored} ->
              if Enum.member?(explored, child) == true do
                {frontier, explored}
              else
                frontier = Stack.push(frontier, Node.new(child, current_node))
                explored = MapSet.put(explored, child)
                {frontier, explored}
              end
            end
          )

        dfs(maze, frontier, explored, goal_fn, successors_fn)
      end
    end
  end

  @spec breadth_first_search(
          a,
          b,
          (b -> boolean),
          (a, b -> list(b))
        ) :: Node.t()
        when a: var, b: var
  def breadth_first_search(maze, initial, goal_fn, successors_fn) do
    frontier =
      Queue.new()
      |> Queue.push(Node.new(initial, nil))

    explored =
      MapSet.new()
      |> MapSet.put(initial)

    bfs(maze, frontier, explored, goal_fn, successors_fn)
  end

  @spec bfs(
          a,
          Queue.t(),
          MapSet.t(),
          (b -> boolean),
          (a, b -> list(b))
        ) :: Node.t()
        when a: var, b: var
  defp bfs(maze, frontier, explored, goal_fn, successors_fn) do
    if Queue.empty?(frontier) == false do
      {current_node, frontier} = Queue.pop(frontier)
      current_state = current_node.state

      if goal_fn.(current_state) do
        current_node
      else
        {frontier, explored} =
          Enum.reduce(
            successors_fn.(maze, current_state),
            {frontier, explored},
            fn child, {frontier, explored} ->
              if Enum.member?(explored, child) == true do
                {frontier, explored}
              else
                frontier = Queue.push(frontier, Node.new(child, current_node))
                explored = MapSet.put(explored, child)
                {frontier, explored}
              end
            end
          )

        bfs(maze, frontier, explored, goal_fn, successors_fn)
      end
    end
  end

  @spec astar_search(
          a,
          b,
          (b -> boolean),
          (a, b -> list(b)),
          (b -> non_neg_integer)
        ) :: Node.t()
        when a: var, b: var
  def astar_search(maze, initial, goal_fn, successors_fn, heuristic_fn) do
    frontier =
      PriorityQueue.new()
      |> PriorityQueue.push(Node.new(initial, nil, 0.0, heuristic_fn.(initial)))

    explored =
      Map.new()
      |> Map.put(initial, 0.0)

    astar(maze, frontier, explored, goal_fn, successors_fn, heuristic_fn)
  end

  #  Dialyzer really dislikes this spec and its permutations and claims the function has no local return. I am unsure of what it has a problem with specifically.
  #  @spec astar(
  #          a,
  #          PriorityQueue.t(Node.t()),
  #          map,
  #          (b -> boolean),
  #          (a, b -> list(b)),
  #          (b -> non_neg_integer)
  #        ) :: Node.t() when a: var, b: var
  defp astar(maze, frontier, explored, goal_fn, successors_fn, heuristic_fn) do
    if PriorityQueue.empty?(frontier) == false do
      {current_node, frontier} = PriorityQueue.pop(frontier)
      current_state = current_node.state

      if goal_fn.(current_state) do
        current_node
      else
        {frontier, explored} =
          Enum.reduce(
            successors_fn.(maze, current_state),
            {frontier, explored},
            fn child, {frontier, explored} ->
              new_cost = current_node.cost + 1

              if Enum.member?(explored, child) or Map.get(explored, child) <= new_cost do
                {frontier, explored}
              else
                frontier =
                  PriorityQueue.push(
                    frontier,
                    Node.new(child, current_node, new_cost, heuristic_fn.(child))
                  )

                explored = Map.put(explored, child, new_cost)
                {frontier, explored}
              end
            end
          )

        astar(maze, frontier, explored, goal_fn, successors_fn, heuristic_fn)
      end
    end
  end

  @spec node_to_path(Node.t()) :: list(Node.t())
  def node_to_path(n) when n == nil do
    []
  end

  def node_to_path(n) when n != nil do
    path = [n.state]
    node_to_path(n, path)
  end

  defp node_to_path(n, path) do
    if n.parent == nil do
      path
    else
      n = n.parent
      node_to_path(n, [n.state | path])
    end
  end
end
