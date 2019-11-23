defmodule CCSP.Chapter3.WordSearchConstraint do
  alias __MODULE__, as: T

  @moduledoc false

  # TODO: way to abstract variables into protocol?
  defstruct variables: []

  def new(words) do
    %T{variables: words}
  end
end

defimpl CCSP.Chapter3.Constraint, for: CCSP.Chapter3.WordSearchConstraint do
  alias CCSP.Chapter3.WordSearchConstraint

  def satisfied?(_constraint, assignment) do
    # if there are any duplicates grid locations, then there is an overlap
    all_locations =
      Enum.flat_map(Map.values(assignment), fn values ->
        values
      end)

    MapSet.size(MapSet.new(all_locations)) == length(all_locations)
  end
end
