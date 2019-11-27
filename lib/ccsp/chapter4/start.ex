defmodule CCSP.Chapter4.Start do
  alias CCSP.Chapter4.Graph
  alias CCSP.Chapter4.WeightedGraph
  alias CCSP.Chapter4.WeightedEdge
  alias CCSP.Chapter4.MST
  alias CCSP.Chapter4.Dijkstra
  alias CCSP.Chapter2.GenericSearch

  @moduledoc """
    Convenience module to for setting up and running more elaborate sections.

    Good idea to migrate into some form of test
  """

  def undirected_graph() do
    city_graph =
      Graph.new([
        "Seattle",
        "San Francisco",
        "Los Angeles",
        "Riverside",
        "Phoenix",
        "Chicago",
        "Boston",
        "New York",
        "Atlanta",
        "Miami",
        "Dallas",
        "Houston",
        "Detroit",
        "Philadelphia",
        "Washington"
      ])

    city_graph
    |> Graph.add_edge_by_vertices("Seattle", "Chicago")
    |> Graph.add_edge_by_vertices("Seattle", "San Francisco")
    |> Graph.add_edge_by_vertices("San Francisco", "Riverside")
    |> Graph.add_edge_by_vertices("San Francisco", "Los Angeles")
    |> Graph.add_edge_by_vertices("Los Angeles", "Riverside")
    |> Graph.add_edge_by_vertices("Los Angeles", "Phoenix")
    |> Graph.add_edge_by_vertices("Riverside", "Phoenix")
    |> Graph.add_edge_by_vertices("Riverside", "Chicago")
    |> Graph.add_edge_by_vertices("Phoenix", "Dallas")
    |> Graph.add_edge_by_vertices("Phoenix", "Houston")
    |> Graph.add_edge_by_vertices("Dallas", "Chicago")
    |> Graph.add_edge_by_vertices("Dallas", "Atlanta")
    |> Graph.add_edge_by_vertices("Dallas", "Houston")
    |> Graph.add_edge_by_vertices("Houston", "Atlanta")
    |> Graph.add_edge_by_vertices("Houston", "Miami")
    |> Graph.add_edge_by_vertices("Atlanta", "Chicago")
    |> Graph.add_edge_by_vertices("Atlanta", "Washington")
    |> Graph.add_edge_by_vertices("Atlanta", "Miami")
    |> Graph.add_edge_by_vertices("Miami", "Washington")
    |> Graph.add_edge_by_vertices("Chicago", "Detroit")
    |> Graph.add_edge_by_vertices("Detroit", "Boston")
    |> Graph.add_edge_by_vertices("Detroit", "Washington")
    |> Graph.add_edge_by_vertices("Detroit", "New York")
    |> Graph.add_edge_by_vertices("Boston", "New York")
    |> Graph.add_edge_by_vertices("New York", "Philadelphia")
    |> Graph.add_edge_by_vertices("Philadelphia", "Washington")
  end

  def weighted_graph() do
    city_graph =
      WeightedGraph.new([
        "Seattle",
        "San Francisco",
        "Los Angeles",
        "Riverside",
        "Phoenix",
        "Chicago",
        "Boston",
        "New York",
        "Atlanta",
        "Miami",
        "Dallas",
        "Houston",
        "Detroit",
        "Philadelphia",
        "Washington"
      ])

    city_graph
    |> WeightedGraph.add_edge_by_vertices("Seattle", "Chicago", 1737)
    |> WeightedGraph.add_edge_by_vertices("Seattle", "San Francisco", 678)
    |> WeightedGraph.add_edge_by_vertices("San Francisco", "Riverside", 386)
    |> WeightedGraph.add_edge_by_vertices("San Francisco", "Los Angeles", 348)
    |> WeightedGraph.add_edge_by_vertices("Los Angeles", "Riverside", 50)
    |> WeightedGraph.add_edge_by_vertices("Los Angeles", "Phoenix", 357)
    |> WeightedGraph.add_edge_by_vertices("Riverside", "Phoenix", 307)
    |> WeightedGraph.add_edge_by_vertices("Riverside", "Chicago", 1704)
    |> WeightedGraph.add_edge_by_vertices("Phoenix", "Dallas", 887)
    |> WeightedGraph.add_edge_by_vertices("Phoenix", "Houston", 1015)
    |> WeightedGraph.add_edge_by_vertices("Dallas", "Chicago", 805)
    |> WeightedGraph.add_edge_by_vertices("Dallas", "Atlanta", 721)
    |> WeightedGraph.add_edge_by_vertices("Dallas", "Houston", 225)
    |> WeightedGraph.add_edge_by_vertices("Houston", "Atlanta", 702)
    |> WeightedGraph.add_edge_by_vertices("Houston", "Miami", 968)
    |> WeightedGraph.add_edge_by_vertices("Atlanta", "Chicago", 588)
    |> WeightedGraph.add_edge_by_vertices("Atlanta", "Washington", 543)
    |> WeightedGraph.add_edge_by_vertices("Atlanta", "Miami", 604)
    |> WeightedGraph.add_edge_by_vertices("Miami", "Washington", 923)
    |> WeightedGraph.add_edge_by_vertices("Chicago", "Detroit", 238)
    |> WeightedGraph.add_edge_by_vertices("Detroit", "Boston", 613)
    |> WeightedGraph.add_edge_by_vertices("Detroit", "Washington", 396)
    |> WeightedGraph.add_edge_by_vertices("Detroit", "New York", 482)
    |> WeightedGraph.add_edge_by_vertices("Boston", "New York", 190)
    |> WeightedGraph.add_edge_by_vertices("New York", "Philadelphia", 81)
    |> WeightedGraph.add_edge_by_vertices("Philadelphia", "Washington", 123)
  end

  def find_shortest_path(initial \\ "Boston", final \\ "Miami") do
    results =
      GenericSearch.breadth_first_search(
        undirected_graph(),
        initial,
        &(&1 == final),
        &Graph.neighbors_for_vertex/2
      )

    if results == nil do
      IO.puts("No solution found for bfs")
    else
      path = GenericSearch.node_to_path(results)
      IO.puts("Path from Boston to Miami:")
      path
    end
  end

  def find_minimum_spanning_tree() do
    wg = weighted_graph()
    result = MST.mst(wg)
    print_weighted_path(wg, result)
  end

  def find_weighted_shortest_path() do
    wg = weighted_graph()
    {distances, path_dict} = Dijkstra.dijkstra(wg, "Los Angeles")
    name_distance = Dijkstra.distance_array_to_vertex_dict(wg, distances)
    IO.puts("Distances from Los Angeles:")

    name_distance
    |> Map.to_list()
    |> Enum.each(fn {key, value} ->
      IO.puts("#{key} : #{value}")
    end)

    IO.puts("")
    IO.puts("Shortest path from Los Angeles to Boston:")
    start = WeightedGraph.index_of(wg, "Los Angeles")
    goal = WeightedGraph.index_of(wg, "Boston")
    path = Dijkstra.path_dict_to_path(start, goal, path_dict)

    print_weighted_path(wg, path)
  end

  defp print_weighted_path(wg, wp) do
    Enum.each(wp, fn edge ->
      u = WeightedGraph.vertex_at(wg, edge.u)
      weight = edge.weight
      v = WeightedGraph.vertex_at(wg, edge.v)
      IO.puts("#{u} #{weight} -> #{v}")
    end)

    IO.puts("Total weight: #{total_weight(wp)}")
  end

  @type weighted_path :: list(WeightedEdge.t())
  @spec total_weight(weighted_path) :: non_neg_integer
  def total_weight(wp) do
    Enum.map(wp, fn edge ->
      edge.weight
    end)
    |> Enum.sum()
  end
end
