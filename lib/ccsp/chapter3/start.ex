defmodule CCSP.Chapter3.Start do
  alias CCSP.Chapter3.CSP
  alias CCSP.Chapter3.QueensConstraint
  alias CCSP.Chapter3.MapColoringConstraint

  @moduledoc """
  Convenience module to for setting up and running more elaborate sections.
  """

  def run_map_coloring() do
    variables = [
      "Western Australia",
      "Northern Territory",
      "South Australia",
      "Queensland",
      "New South Wales",
      "Victoria",
      "Tasmania"
    ]

    domains =
      Enum.reduce(variables, %{}, fn variable, acc ->
        Map.put(acc, variable, ["red", "green", "blue"])
      end)

    csp = CSP.new(variables, domains)

    result =
      CSP.add_constraint(
        csp,
        MapColoringConstraint.new("Western Australia", "Northern Territory")
      )
      |> CSP.add_constraint(MapColoringConstraint.new("Western Australia", "South Australia"))
      |> CSP.add_constraint(MapColoringConstraint.new("South Australia", "Northern Territory"))
      |> CSP.add_constraint(MapColoringConstraint.new("Queensland", "Northern Territory"))
      |> CSP.add_constraint(MapColoringConstraint.new("Queensland", "South Australia"))
      |> CSP.add_constraint(MapColoringConstraint.new("Queensland", "New South Wales"))
      |> CSP.add_constraint(MapColoringConstraint.new("New South Wales", "South Australia"))
      |> CSP.add_constraint(MapColoringConstraint.new("Victoria", "South Australia"))
      |> CSP.add_constraint(MapColoringConstraint.new("Victoria", "New South Wales"))
      |> CSP.add_constraint(MapColoringConstraint.new("Victoria", "Tasmania"))
      |> CSP.backtracking_search()

    result
  end

  def run_queens(n \\ 8) do
    columns = Enum.to_list(1..n)

    rows =
      Enum.reduce(columns, %{}, fn column, acc ->
        Map.put(acc, column, Enum.to_list(1..n))
      end)

    CSP.new(columns, rows)
    |> CSP.add_constraint(QueensConstraint.new(columns))
    |> CSP.backtracking_search()
    |> (&(if nil == &1 do
            {:error, "No solution found."}
          else
            &1
          end)).()
  end
end
