defmodule CCSP.Chapter3.SendMoreMoneyConstraint do
  alias __MODULE__, as: T

  @moduledoc false

  # TODO: way to abstract variables into protocol?
  defstruct variables: []

  def new(letters) do
    %T{variables: letters}
  end
end

defimpl CCSP.Chapter3.Constraint, for: CCSP.Chapter3.SendMoreMoneyConstraint do
  def satisfied?(constraint, assignment) do
    cond do
      MapSet.size(MapSet.new(Map.values(assignment))) < map_size(assignment) -> false
      map_size(assignment) == length(constraint.variables) -> check_variables(assignment)
      true -> true
    end
  end

  defp check_variables(assignment) do
    s = Map.get(assignment, "S")
    e = Map.get(assignment, "E")
    n = Map.get(assignment, "N")
    d = Map.get(assignment, "D")
    m = Map.get(assignment, "M")
    o = Map.get(assignment, "O")
    r = Map.get(assignment, "R")
    y = Map.get(assignment, "Y")
    send = s * 1000 + e * 100 + n * 10 + d
    more = m * 1000 + o * 100 + r * 10 + e
    money = m * 10_000 + o * 1_000 + n * 100 + e * 10 + y

    send + more == money
  end
end
