defmodule CCSP.Chapter3.SendMoreMoneyConstraint do
  alias __MODULE__, as: T

  @moduledoc false

  # TODO: way to abstract variables into protocol?
  defstruct variables: [], letters: []

  def new(letters) do
    %T{variables: letters, letters: letters}
  end

  def check_variables(assignment) do
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
    money = m * 10000 + o * 1000 + n * 100 + e * 10 + y

    send + more == money
  end
end

defimpl CCSP.Chapter3.Constraint, for: CCSP.Chapter3.SendMoreMoneyConstraint do
  alias CCSP.Chapter3.SendMoreMoneyConstraint

  def satisfied?(constraint, assignment) do
    cond do
      MapSet.size(MapSet.new(Map.values(assignment))) < map_size(assignment) -> false
      map_size(assignment) == length(constraint.letters) -> SendMoreMoneyConstraint.check_variables(assignment)
      true -> true
    end
  end
end
