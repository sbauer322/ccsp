defmodule CCSP.Chapter3.MapColoringConstraint do
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Section 3.2, titled "Australian map-coloring problem"
  """

  defstruct variables: [], place1: "", place2: ""

  def new(place1, place2) do
    %T{variables: [place1, place2], place1: place1, place2: place2}
  end
end

defimpl CCSP.Chapter3.Constraint, for: CCSP.Chapter3.MapColoringConstraint do
  def satisfied?(constraint, assignment) do
    if not Map.has_key?(assignment, constraint.place1) or
         not Map.has_key?(assignment, constraint.place2) do
      true
    else
      Map.get(assignment, constraint.place1) != Map.get(assignment, constraint.place2)
    end
  end
end
