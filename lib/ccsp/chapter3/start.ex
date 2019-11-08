defmodule CCSP.Chapter3.Start do
  alias CCSP.Chapter3.CSP
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

    CSP.add_constraint(csp, MapColoringConstraint.new("Western Australia", "Northern Territory"))
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
  end
end
