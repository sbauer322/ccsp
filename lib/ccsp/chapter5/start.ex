defmodule CCSP.Chapter5.Start do
  alias CCSP.Chapter5.SimpleEquation
  alias CCSP.Chapter5.GeneticAlgorithm
  alias CCSP.Chapter5.Chromosome

  @moduledoc """
    Convenience module for setting up and running more elaborate sections.
  """

  def run_simple_equation() do
    initial_population =
      Enum.map(0..20, fn _i ->
        SimpleEquation.random_instance()
      end)

    threshold = 13
    max_generations = 100
    mutation_chance = 0.1
    crossover_chance = 0.7

    ga =
      GeneticAlgorithm.new(
        initial_population,
        threshold,
        max_generations,
        mutation_chance,
        crossover_chance
      )

    result = GeneticAlgorithm.run(ga)

    if threshold - 1 <= Chromosome.fitness(result) and Chromosome.fitness(result) <= threshold + 1 do
      result
    else
      simple_equation
    end
  end
end
