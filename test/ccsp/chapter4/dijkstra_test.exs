defmodule CCSP.Chapter4.DijkstraTest do
  use ExUnitProperties
  use ExUnit.Case
  alias CCSP.Chapter4.Dijkstra
  alias CCSP.Chapter4.WeightedGraph
  alias CCSP.Chapter4.Start
  @moduledoc false

  test "weighted graph against dijkstra" do
    expected = [
      {"Los Angeles", "Riverside", 50},
      {"Riverside", "Chicago", 1704},
      {"Chicago", "Detroit", 238},
      {"Detroit", "Boston", 613}
    ]

    wg = Start.weighted_graph()
    {_, path_dict} = Dijkstra.dijkstra(wg, "Los Angeles")
    start = WeightedGraph.index_of(wg, "Los Angeles")
    goal = WeightedGraph.index_of(wg, "Boston")
    path = Dijkstra.path_dict_to_path(start, goal, path_dict)

    # transform the path produced into something more manageable
    actual = Enum.map(path, fn edge ->
      u = WeightedGraph.vertex_at(wg, edge.u)
      weight = edge.weight
      v = WeightedGraph.vertex_at(wg, edge.v)
      {u, v, weight}
    end)

    assert expected == actual
  end
end