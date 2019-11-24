defmodule CCSP.Chapter4.Start do
  alias CCSP.Chapter4.Graph

  @moduledoc """
    Convenience module to for setting up and running more elaborate sections.

    Good idea to migrate into some form of test
  """

  def basic_graph() do
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
end
