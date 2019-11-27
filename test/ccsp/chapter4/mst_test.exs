defmodule CCSP.Chapter4.MSTTest do
  use ExUnitProperties
  use ExUnit.Case
  alias CCSP.Chapter4.MST
  alias CCSP.Chapter4.WeightedGraph
  alias CCSP.Chapter4.Start
  @moduledoc false

  test "weighted graph against minimum spanning tree" do
    expected = [
      {"Atlanta", "Miami", 604},
      {"Detroit", "Chicago", 238},
      {"Washington", "Detroit", 396},
      {"New York", "Boston", 190},
      {"Philadelphia", "New York", 81},
      {"Washington", "Philadelphia", 123},
      {"Atlanta", "Washington", 543},
      {"Houston", "Atlanta", 702},
      {"Dallas", "Houston", 225},
      {"Phoenix", "Dallas", 887},
      {"Riverside", "Phoenix", 307},
      {"Los Angeles", "Riverside", 50},
      {"San Francisco", "Los Angeles", 348},
      {"Seattle", "San Francisco", 678}
    ]

    wg = Start.weighted_graph()
    result = MST.mst(wg)

    # transform the path produced into something more manageable
    actual = Enum.map(result, fn edge ->
      u = WeightedGraph.vertex_at(wg, edge.u)
      weight = edge.weight
      v = WeightedGraph.vertex_at(wg, edge.v)
      {u, v, weight}
    end)

    assert expected == actual
  end

end