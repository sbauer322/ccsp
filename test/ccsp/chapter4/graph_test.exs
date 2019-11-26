defmodule CCSP.Chapter4.GraphTest do
  use ExUnitProperties
  use ExUnit.Case
  alias CCSP.Chapter2.GenericSearch
  alias CCSP.Chapter4.Graph
  alias CCSP.Chapter4.Start
  @moduledoc false

  test "undirected graph against breadth first search" do
    expected = [
      "Boston",
      "Detroit",
      "Washington",
      "Miami"
    ]

    results =
      GenericSearch.breadth_first_search(
        Start.undirected_graph(),
        "Boston",
        &(&1 == "Miami"),
        &Graph.neighbors_for_vertex/2
      )

    path = GenericSearch.node_to_path(results)

    assert expected == path
  end
end