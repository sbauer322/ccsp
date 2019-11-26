defmodule CCSP.Chapter4.Dijkstra do
  alias __MODULE__, as: T
  alias CCSP.Chapter4.DijkstraNode
  alias CCSP.Chapter4.WeightedGraph
  alias CCSP.Chapter4.WeightedEdge
  alias CCSP.Chapter2.PriorityQueue

  @moduledoc """
  Corresponds to CCSP in Python, Chapter 4, titled "Graph Problems"
  """

  @type a :: any
  @type weighted_path :: list(WeightedEdge.t())
  @type t :: __MODULE__.t()

  @spec dijkstra(WeightedGraph.t(), a) :: {list(integer | nil), %{integer => WeightedEdge.t()}}
  def dijkstra(wg, root) do
    first = WeightedGraph.index_of(wg, root)

    distances = List.duplicate(nil, WeightedGraph.vertex_count(wg))
    distances = List.update_at(distances, first, fn _ -> 0 end)
    path = %{}
    pq = PriorityQueue.new()
    pq = PriorityQueue.push(pq, DijkstraNode.new(first, 0))

    {distances, path} = dijkstra_helper(wg, pq, distances, path)
    {distances, path}
  end

  @spec dijkstra_helper(
          WeightedGraph.t(),
          PriorityQueue.t(WeightedEdge.t()),
          list(integer | nil),
          %{
            integer => WeightedEdge.t()
          }
        ) :: {list(integer | nil), %{integer => WeightedEdge.t()}}
  def dijkstra_helper(wg, pq, distances, path) do
    if PriorityQueue.empty?(pq) do
      {distances, path}
    else
      {node, pq} = PriorityQueue.pop(pq)
      u = node.vertex
      dist_u = Enum.at(distances, u)

      {pq, distances, path} =
        Enum.reduce(
          WeightedGraph.edges_for_index(wg, u),
          {pq, distances, path},
          fn we, {pq, distances, path} ->
            dist_v = Enum.at(distances, we.v)

            if dist_v == nil or dist_v > we.weight + dist_u do
              distances = List.update_at(distances, we.v, fn _ -> we.weight + dist_u end)
              path = Map.put(path, we.v, we)
              pq = PriorityQueue.push(pq, DijkstraNode.new(we.v, we.weight + dist_u))
              {pq, distances, path}
            else
              {pq, distances, path}
            end
          end
        )

      dijkstra_helper(wg, pq, distances, path)
    end
  end

  @spec distance_array_to_vertex_dict(
          WeightedGraph.t(),
          list(integer | nil)
        ) :: %{
          a => integer | nil
        }
  def distance_array_to_vertex_dict(wg, distances) do
    Enum.reduce(0..(length(distances) - 1), %{}, fn i, distance_dict ->
      vertex = WeightedGraph.vertex_at(wg, i)
      Map.put(distance_dict, vertex, Enum.at(distances, i))
    end)
  end

  @spec path_dict_to_path(integer, integer, %{integer => WeightedEdge.t()}) :: weighted_path
  def path_dict_to_path(_, _, path_dict) when %{} == path_dict do
    []
  end

  def path_dict_to_path(start, goal, path_dict) do
    edge_path = []
    e = Map.get(path_dict, goal)
    edge_path = [e | edge_path]

    path_dict_to_path_helper(path_dict, edge_path, e, start)
  end

  @spec path_dict_to_path_helper(
          %{integer => WeightedEdge.t()},
          list(WeightedEdge.t()),
          WeightedEdge.t(),
          integer
        ) :: list(WeightedEdge.t())
  defp path_dict_to_path_helper(path_dict, edge_path, e, start) do
    if e.u == start do
      edge_path
    else
      e = Map.get(path_dict, e.u)
      edge_path = [e | edge_path]
      path_dict_to_path_helper(path_dict, edge_path, e, start)
    end
  end
end
