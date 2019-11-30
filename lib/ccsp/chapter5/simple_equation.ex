defmodule CCSP.Chapter5.SimpleEquation do
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Chapter 5, titled "Genetic Algorithms"
  """

  @type t :: %T{
          x: integer,
          y: integer
        }

  defstruct [
    :x,
    :y
  ]

  @spec new(integer, integer) :: t
  def new(x, y) do
    %T{x: x, y: y}
  end

  @spec random_instance() :: t
  def random_instance() do
    new(Enum.random(0..100), Enum.random(0..100))
  end
end

defimpl CCSP.Chapter5.Chromosome, for: CCSP.Chapter5.SimpleEquation do
  alias CCSP.Chapter5.SimpleEquation
  alias __MODULE__, as: T

  @type t :: __MODULE__.t()

  @spec fitness(t) :: t
  def fitness(c) do
    # 6x - x^2 + 4y - y^2
    6 * c.x - c.x * c.x + 4 * c.y - c.y * c.y
  end

  @spec crossover(t, t) :: {t, t}
  def crossover(c1, c2) do
    child1 = %{c1 | :y => c2.y}
    child2 = %{c2 | :y => c1.y}

    {child1, child2}
  end

  @spec mutate(t) :: t
  def mutate(c) do
    if :rand.uniform() > 0.5 do
      if :rand.uniform() > 0.5 do
        %SimpleEquation{c | :x => c.x + 1}
      else
        %SimpleEquation{c | :x => c.x - 1}
      end
    else
      if :rand.uniform() > 0.5 do
        %SimpleEquation{c | :y => c.y + 1}
      else
        %SimpleEquation{c | :y => c.y - 1}
      end
    end
  end
end

defimpl Inspect, for: CCSP.Chapter5.SimpleEquation do
  alias CCSP.Chapter5.Chromosome
  alias CCSP.Chapter5.SimpleEquation

  def inspect(c, _opts) do
    fitness = Chromosome.fitness(c)
    "X: #{c.x} Y: #{c.y} Fitness: #{fitness}"
  end
end

defimpl String.Chars, for: CCSP.Chapter5.SimpleEquation do
  alias CCSP.Chapter5.Chromosome
  alias CCSP.Chapter5.SimpleEquation

  def to_string(c) do
    fitness = Chromosome.fitness(c)
    "X: #{c.x} Y: #{c.y} Fitness: #{fitness}"
  end
end
