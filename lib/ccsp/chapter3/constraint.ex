defprotocol CCSP.Chapter3.Constraint do
  # variable type
  @type v :: any
  # domain type
  @type d :: any
  @type abc :: any
  @type t(v, d) :: __MODULE__.t(v, d)

  #  @spec new(list(v)) :: t(v, d)
  #  def new(variables)

  @spec satisfied?(t(v, d), %{v => d}) :: boolean
  def satisfied?(constraint, assignment)
end
