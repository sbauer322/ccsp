defmodule CCSP.Chapter4.MST do
  alias __MODULE__, as: T
  alias CCSP.Chapter4.WeightedGraph
  alias CCSP.Chapter4.WeightedEdge
  alias CCSP.Chapter2.PriorityQueue

  @moduledoc """
    Corresponds to CCSP in Python, Chapter 4, titled "Graph problems"
  """

  @type weighted_path :: list(WeightedEdge.t())

  @spec total_weight(weighted_path) :: non_neg_integer
  def total_weight(wp) do
    Enum.map(wp, fn edge ->
      edge.weight
    end)
    |> Enum.sum()
  end

  @spec mst(WeightedGraph.t(), non_neg_integer) :: weighted_path | nil
  def mst(wg, start \\ 0) do
    if start > WeightedGraph.vertex_count(wg) - 1 or start < 0 do
      nil
    else
      result = []
      pq = PriorityQueue.new()
      visited = List.duplicate(false, WeightedGraph.vertex_count(wg))
      {visited, pq} = visit(wg, visited, pq, start)

      result = mst_helper(wg, visited, pq, result)
      result
    end
  end

  @spec visit(WeightedGraph.t(), list(boolean), PriorityQueue.t(WeightedEdge.t), non_neg_integer) ::
          {list(boolean), PriorityQueue.t(WeightedEdge.t)}
  defp visit(wg, visited, pq, index) do
    visited = List.update_at(visited, index, fn _ -> true end)

    pq =
      WeightedGraph.edges_for_index(wg, index)
      |> Enum.reduce(pq, fn edge, acc ->
        if Enum.at(visited, edge.v) do
          acc
        else
          PriorityQueue.push(acc, edge)
        end
      end)

    {visited, pq}
  end

  defp mst_helper(wg, visited, pq, result) do
    with false <- PriorityQueue.empty?(pq),
         {edge, pq} <- PriorityQueue.pop(pq) do
      if Enum.at(visited, edge.v) do
        mst_helper(wg, visited, pq, result)
      else
        result = [edge | result]
        {visited, pq} = visit(wg, visited, pq, edge.v)
        mst_helper(wg, visited, pq, result)
      end
    else
      _ -> result
    end
  end

  def print_weighted_path(wg, wp) do
    Enum.each(wp, fn edge ->
      u = WeightedGraph.vertex_at(wg, edge.u)
      weight = edge.weight
      v = WeightedGraph.vertex_at(wg, edge.v)
      IO.puts("#{u} #{weight} -> #{v}")
    end)

    IO.puts("Total weight: #{total_weight(wp)}")
  end
end
