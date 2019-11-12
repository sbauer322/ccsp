defmodule CCSP.Chapter3.QueensConstraint do
  alias __MODULE__, as: T

  @moduledoc false

  # TODO: way to abstract variables into protocol?
  defstruct variables: [], columns: []

  def new(columns) do
    %T{variables: columns, columns: columns}
  end

  def same_row?(q1r, q2r) do
    q1r == q2r
  end

  def same_diagonal?(q1r, q1c, q2r, q2c) do
    abs(q1r - q2r) == abs(q1c - q2c)
  end

  def threat?(q1r, q1c, q2r, q2c) do
    same_row?(q1r, q2r) or same_diagonal?(q1r, q1c, q2r, q2c)
  end

  def queen_safe?(assignment, q1r, q1c, q2c) do
    if Map.has_key?(assignment, q2c) do
      q2r = Map.get(assignment, q2c)
      not threat?(q1r, q1c, q2r, q2c)
    else
      true
    end
  end
end

defimpl CCSP.Chapter3.Constraint, for: CCSP.Chapter3.QueensConstraint do
  alias CCSP.Chapter3.QueensConstraint

  def satisfied?(constraint, assignment) do
    # q1c = queen 1 column, q1r = queen 1 row
    Enum.all?(Map.to_list(assignment), fn {q1c, q1r} ->
      # q2c = queen 2 column
      Enum.all?((q1c + 1)..(length(constraint.columns) + 1), fn q2c ->
        QueensConstraint.queen_safe?(assignment, q1r, q1c, q2c)
      end)
    end)
  end
end
