defmodule CCSP.Chapter4.Graph do
  alias __MODULE__, as: T
  alias CCSP.Chapter4.Edge

  @moduledoc """
    Corresponds to CCSP in Python, Section 4.2, titled "Building a graph framework"


    This module may be a good candidate to use a gen server.

    Also good candidate for converting lists to maps for better lookup times
  """

  defstruct [:vertices, :edges]

  @type a :: any
  @type t :: %T{
          vertices: list(a),
          edges: list(list(Edge.t()))
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
      |> List.update_at(edge.v, &[Edge.reversed(edge) | &1])

    %T{vertices: graph.vertices, edges: edges}
  end

  @spec add_edge_by_indicies(t, non_neg_integer, non_neg_integer) :: t
  def add_edge_by_indicies(graph, u, v) do
    add_edge(graph, Edge.new(u, v))
  end

  @spec add_edge_by_vertices(t, a, a) :: t
  def add_edge_by_vertices(graph, first, second) do
    u = Enum.find_index(graph.vertices, &(&1 == first))
    v = Enum.find_index(graph.vertices, &(&1 == second))
    add_edge_by_indicies(graph, u, v)
  end

  @spec vertex_at(t, non_neg_integer) :: a
  def vertex_at(graph, index) do
    Enum.at(graph.vertices, index)
  end

  @spec index_of(t, a) :: non_neg_integer
  def index_of(graph, vertex) do
    Enum.find(graph.vertices, vertex)
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

  @spec edges_for_index(t, non_neg_integer) :: list(Edge.t())
  def edges_for_index(graph, index) do
    Enum.at(graph.edges, index)
  end

  @spec edges_for_vertex(t, a) :: list(Edge.t())
  def edges_for_vertex(graph, vertex) do
    edges_for_index(graph, Enum.find_index(graph.vertices, &(&1 == vertex)))
  end
end

defimpl Inspect, for: CCSP.Chapter4.Graph do
  alias CCSP.Chapter4.Graph

  def inspect(graph, _opts) do
    Enum.reduce(0..(Graph.vertex_count(graph) - 1), "", fn i, acc ->
      vertex = Graph.vertex_at(graph, i)
      vertex_neighbors = Graph.neighbors_for_index(graph, i)

      acc <> "#{vertex} -> #{Enum.join(vertex_neighbors, ", ")}\n"
    end)
  end
end
