defprotocol CCSP.Chapter5.Chromosome do
  @moduledoc """
  Corresponds to CCSP in Python, Chapter 5, titled "Genetic Algorithms".

  As Elixir lacks OO-style inheritance, we rely on a protocol to obtain polymorphism.

  random_instance is defined in CCSPiP on the abstract class, however, it seems in Elixir we cannot define a function in a protocol with zero arguments. To work around this, we define the function in the implementing module instead. This should not be an issue as the function is not required in the GeneticAlgorithm module
  """

  def fitness(c)

  #  def random_instance()

  def crossover(c1, c2)

  def mutate(c)
end
