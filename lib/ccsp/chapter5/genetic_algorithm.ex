defmodule CCSP.Chapter5.GeneticAlgorithm do
  alias __MODULE__, as: T
  alias CCSP.Chapter5.Chromosome

  @moduledoc """
  Corresponds to CCSP in Python, Chapter 5, titled "Genetic Algorithms"
  """

  @type c :: Chromosome.t()
  @type t :: %T{
          population: list(c),
          threshold: float | integer,
          max_generations: integer,
          mutation_chance: float,
          crossover_chance: float,
          selection_type: atom,
          fitness_key: (c -> c)
        }

  defstruct [
    :population,
    :threshold,
    :max_generations,
    :mutation_chance,
    :crossover_chance,
    :selection_type,
    :fitness_key
  ]

  @spec new(list(c), float | integer, integer, float, float, atom) :: t
  def new(
        population,
        threshold,
        max_generations \\ 100,
        mutation_chance \\ 0.01,
        crossover_chance \\ 0.7,
        selection_type \\ :tournament
      ) do
    %T{
      population: population,
      threshold: threshold,
      max_generations: max_generations,
      mutation_chance: mutation_chance,
      crossover_chance: crossover_chance,
      selection_type: selection_type,
      fitness_key: &Chromosome.fitness/1
    }
  end

  @spec run(t) :: c
  def run(ga) do
    best = Enum.max_by(ga.population, ga.fitness_key)

    {_ga, best} =
      Enum.reduce_while(0..ga.max_generations, {ga, best}, fn generation, {ga, best} ->
        if Chromosome.fitness(best) >= ga.threshold do
          {:halt, {ga, best}}
        else
          avg =
            Enum.reduce(ga.population, 0, fn v, acc -> Chromosome.fitness(v) + acc end) /
              length(ga.population)

          IO.puts("Generation #{generation} Best #{Chromosome.fitness(best)} Avg #{avg}")

          ga =
            ga
            |> reproduce_and_replace()
            |> mutate()

          highest = Enum.max_by(ga.population, ga.fitness_key)

          if Chromosome.fitness(highest) > Chromosome.fitness(best) do
            {:cont, {ga, highest}}
          else
            {:cont, {ga, best}}
          end
        end
      end)

    best
  end

  @spec reproduce_and_replace(t) :: t
  def reproduce_and_replace(ga) do
    new_population =
      Enum.reduce_while(ga.population, [], fn _x, acc ->
        if length(acc) < length(ga.population) do
          {p1, p2} =
            cond do
              :roulette == ga.selection_type ->
                fitnesses = Enum.map(ga.population, &Chromosome.fitness(&1))
                pick_roulette(ga, fitnesses)

              :tournament == ga.selection_type ->
                pick_tournament(ga, length(ga.population))

              true ->
                IO.puts("Unhandled selection type")
            end

          new_population =
            if :rand.uniform() < ga.crossover_chance do
              {c1, c2} = Chromosome.crossover(p1, p2)
              acc ++ [c1, c2]
            else
              acc ++ [p1, p2]
            end

          {:cont, new_population}
        else
          {:halt, acc}
        end
      end)

    new_population =
      if length(new_population) > length(ga.population) do
        tl(new_population)
      else
        new_population
      end

    %T{ga | :population => new_population}
  end

  @spec mutate(t) :: t
  def mutate(ga) do
    population =
      Enum.map(ga.population, fn element ->
        if :rand.uniform() < ga.mutation_chance do
          Chromosome.mutate(element)
        else
          element
        end
      end)

    %T{ga | :population => population}
  end

  @spec pick_roulette(t, list(float)) :: {c, c}
  def pick_roulette(ga, wheel) do
    choices(ga.population, wheel, 2)
    |> List.to_tuple()
  end

  @spec pick_tournament(t, non_neg_integer) :: {c, c}
  def pick_tournament(ga, num_participants) do
    participants = choices(ga.population, nil, num_participants)

    Enum.sort_by(participants, ga.fitness_key, &>=/2)
    |> Enum.take(2)
    |> List.to_tuple()
  end

  @doc """
  Given the list of elements and (non-cumulative) weights, returns k random elements. Duplicates are possible.

  choices functions are loosely adapted from cpython https://github.com/python/cpython/blob/master/Lib/random.py#L397
  """
  @spec choices(list(any), list(float) | nil, non_neg_integer) :: list(any)
  def choices(population, weights, k) when k > 0 do
    n = length(population)
    k = k - 1

    if weights == nil do
      Enum.reduce(0..k, [], fn _i, acc ->
        element = Enum.at(population, trunc(:rand.uniform() * n))
        [element | acc]
      end)
    else
      cum_weights = Enum.scan(weights, 0, &(&1 + &2))
      choices_weighted(population, cum_weights, k, n)
    end
  end

  @spec choices_weighted(list(any), list(float), non_neg_integer, non_neg_integer) :: list(any)
  def choices_weighted(population, cum_weights, k, n) when k > 0 and n > 0 do
    total = hd(Enum.reverse(cum_weights))
    sorted_weight = Enum.sort(cum_weights)
    hi = n

    Enum.reduce(0..k, [], fn _i, acc ->
      index = bisect_right(sorted_weight, :rand.uniform() * total, 0, hi)
      element = Enum.at(population, index)
      [element | acc]
    end)
  end

  @doc """
  See https://github.com/python/cpython/blob/master/Lib/bisect.py#L15
  """
  @spec bisect_right(list(integer), float, non_neg_integer, non_neg_integer) :: non_neg_integer
  def bisect_right(a, x, lo, hi) when lo < hi and lo >= 0 do
    # truncates to int
    mid = div(lo + hi, 2)

    {lo, hi} =
      if x < Enum.at(a, mid) do
        {lo, mid}
      else
        {mid + 1, hi}
      end

    bisect_right(a, x, lo, hi)
  end

  def bisect_right(_a, _x, lo, hi) when lo >= hi and lo >= 0 do
    lo
  end
end
