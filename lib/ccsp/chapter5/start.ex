defmodule CCSP.Chapter5.Start do
  alias CCSP.Chapter5.SimpleEquation
  alias CCSP.Chapter5.SendMoreMoney
  alias CCSP.Chapter5.ListCompression
  alias CCSP.Chapter5.GeneticAlgorithm

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

    GeneticAlgorithm.run(ga)
  end

  def run_send_more_money() do
    initial_population =
      Enum.map(0..100, fn _i ->
        SendMoreMoney.random_instance()
      end)

    threshold = 1.0
    max_generations = 1000
    mutation_chance = 0.2
    crossover_chance = 0.7
    selection_type = :roulette

    ga =
      GeneticAlgorithm.new(
        initial_population,
        threshold,
        max_generations,
        mutation_chance,
        crossover_chance,
        selection_type
      )

    GeneticAlgorithm.run(ga)
  end

  def run_list_compression() do
    initial_population =
      Enum.map(0..1000, fn _i ->
        ListCompression.random_instance()
      end)

    threshold = 1.0
    max_generations = 1000
    mutation_chance = 0.2
    crossover_chance = 0.7
    selection_type = :tournament

    ga =
      GeneticAlgorithm.new(
        initial_population,
        threshold,
        max_generations,
        mutation_chance,
        crossover_chance,
        selection_type
      )

    GeneticAlgorithm.run(ga)
  end
end
