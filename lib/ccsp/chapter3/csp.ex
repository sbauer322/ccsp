defmodule CCSP.Chapter3.CSP do
  alias CCSP.Chapter3.Constraint
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Section 3.1, titled "Building a constraint-satisfaction problem framework"
  """

  @type t :: __MODULE__.t()
  # variable type
  @type v :: any
  # domain type
  @type d :: any
  @type domains :: %{v => [d]}

  defstruct variables: [], domains: %{}, constraints: %{}

  @spec new(list(v), domains) :: t()
  def new(variables, domains) do
    constraints =
      Enum.reduce(variables, %{}, fn element, acc ->
        unless Map.has_key?(domains, element) do
          raise "Every variable should have a domain assigned to it."
        end

        Map.put(acc, element, [])
      end)

    %T{variables: variables, domains: domains, constraints: constraints}
  end

  @spec add_constraint(t, Constraint.t(v, d)) :: t
  def add_constraint(csp, constraint) do
    constraints =
      Enum.reduce(constraint.variables, csp.constraints, fn variable, csp_constraints ->
        unless variable in csp.variables do
          raise "Every variable should have a domain assigned to it."
        end

        constraint_list =
          Map.get(csp_constraints, variable)
          |> (&[constraint | &1]).()

        Map.put(csp_constraints, variable, constraint_list)
      end)

    %T{variables: csp.variables, domains: csp.domains, constraints: constraints}
  end

  @spec consistent?(t, v, %{v => d}) :: boolean
  def consistent?(csp, variable, assignment) do
    Map.get(csp.constraints, variable)
    |> Enum.all?(fn constraint -> Constraint.satisfied?(constraint, assignment) end)
  end

  def next_candidate(csp, assignment) do
    [first | _] = Enum.filter(csp.variables, fn v -> not Map.has_key?(assignment, v) end)
    first
  end

  @spec backtracking_search(t, %{v => d}) :: {atom, %{v => d}} | nil
  def backtracking_search(csp, assignment \\ %{})

  def backtracking_search(%T{variables: variables} = _csp, assignment)
      when map_size(assignment) == length(variables) do
    {:ok, assignment}
  end

  def backtracking_search(csp, assignment) do
    first = next_candidate(csp, assignment)

    Map.get(csp.domains, first)
    |> Enum.find_value(fn value ->
      with local_assignment <- Map.put(assignment, first, value),
           true <- consistent?(csp, first, local_assignment),
           results <- backtracking_search(csp, local_assignment),
           true <- is_tuple(results) do
        results
      else
        _ -> nil
      end
    end)
  end
end
