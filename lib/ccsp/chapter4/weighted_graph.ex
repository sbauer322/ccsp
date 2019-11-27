defmodule CCSP.Chapter4.WeightedGraph do
  alias __MODULE__, as: T
  alias CCSP.Chapter4.WeightedEdge

  @moduledoc """
    Corresponds to CCSP in Python, Chapter 4, titled "Graph problems"


    This module may be a good candidate to use a gen server.

    Also good candidate for converting lists to maps for better lookup times
  """

  defstruct [:vertices, :edges]

  @type a :: any
  @type t :: %T{
          vertices: list(a),
          edges: list(list(WeightedEdge.t()))
        }

  @spec new(list(a)) :: t
  def new(vertices) do
    edges =
      Enum.map(vertices, fn _ ->
        []
      end)

    %T{vertices: vertices, edges: edges}
  end

  @spec vertex_count(t) :: non_neg_integer
  def vertex_count(graph) do
    length(graph.vertices)
  end

  @spec edge_count(t) :: non_neg_integer
  def edge_count(graph) do
    Enum.map(graph.edges, fn edge ->
      length(edge)
    end)
    |> Enum.sum()
  end

  @spec add_vertex(t, a) :: t
  def add_vertex(graph, vertex) do
    vertices = [vertex | graph.vertices]
    edges = [[] | graph.edges]
    %T{vertices: vertices, edges: edges}
  end

  @spec add_edge(t, a) :: t
  def add_edge(graph, edge) do
    edges =
      graph.edges
      |> List.update_at(edge.u, &[edge | &1])
      |> List.update_at(edge.v, &[WeightedEdge.reversed(edge) | &1])

    %T{vertices: graph.vertices, edges: edges}
  end

  @spec add_edge_by_indicies(t, non_neg_integer, non_neg_integer, non_neg_integer) :: t
  def add_edge_by_indicies(graph, u, v, weight) do
    add_edge(graph, WeightedEdge.new(u, v, weight))
  end

  @spec add_edge_by_vertices(t, a, a, non_neg_integer) :: t
  def add_edge_by_vertices(graph, first, second, weight) do
    u = Enum.find_index(graph.vertices, &(&1 == first))
    v = Enum.find_index(graph.vertices, &(&1 == second))
    add_edge_by_indicies(graph, u, v, weight)
  end

  @spec vertex_at(t, non_neg_integer) :: a
  def vertex_at(graph, index) do
    Enum.at(graph.vertices, index)
  end

  @spec index_of(t, a) :: non_neg_integer
  def index_of(graph, vertex) do
    Enum.find_index(graph.vertices, fn x -> x == vertex end)
  end

  @spec neighbors_for_index(t, non_neg_integer) :: list(a)
  def neighbors_for_index(graph, index) do
    graph.edges
    |> Enum.at(index)
    |> Enum.map(&vertex_at(graph, &1.v))
  end

  @spec neighbors_for_vertex(t, a) :: list(a)
  def neighbors_for_vertex(graph, vertex) do
    neighbors_for_index(graph, Enum.find_index(graph.vertices, &(&1 == vertex)))
  end

  @spec neighbors_for_index_with_weights(t, non_neg_integer) :: list({a, non_neg_integer})
  def neighbors_for_index_with_weights(graph, index) do
    edges_for_index(graph, index)
    |> Enum.reduce([], fn edge, acc ->
      [{vertex_at(graph, edge.v), edge.weight} | acc]
    end)
  end

  @spec edges_for_index(t, non_neg_integer) :: list(WeightedEdge.t())
  def edges_for_index(graph, index) do
    Enum.at(graph.edges, index)
  end

  @spec edges_for_vertex(t, a) :: list(WeightedEdge.t())
  def edges_for_vertex(graph, vertex) do
    edges_for_index(graph, Enum.find_index(graph.vertices, &(&1 == vertex)))
  end
end

defimpl Inspect, for: CCSP.Chapter4.WeightedGraph do
  alias CCSP.Chapter4.WeightedGraph

  def inspect(graph, _opts) do
    Enum.reduce(0..(WeightedGraph.vertex_count(graph) - 1), "", fn i, acc ->
      vertex = WeightedGraph.vertex_at(graph, i)

      vertex_neighbors =
        WeightedGraph.neighbors_for_index_with_weights(graph, i)
        |> Enum.map(fn neighbor -> "(#{elem(neighbor, 0)}, #{elem(neighbor, 1)})" end)
        |> Enum.join(", ")

      acc <> "#{vertex} -> #{vertex_neighbors}\n"
    end)
  end
end
