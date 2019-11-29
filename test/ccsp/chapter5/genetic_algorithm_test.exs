defmodule CCSP.Chapter5.GeneticAlgorithmTest do
  use ExUnitProperties
  use ExUnit.Case
  alias CCSP.Chapter5.GeneticAlgorithm
  @moduledoc false

  test "choices" do
    population = ["cat", "hat", "mat", "rat"]
    weights = [:rand.uniform(), :rand.uniform(), :rand.uniform(), :rand.uniform()]
    k = 2
    expected = k

    result = GeneticAlgorithm.choices(population, weights, k)
    assert expected == length(result)
  end

  test "list bisect right" do
    a = [14]
    x = 14
    lo = 0
    hi = length(a)
    expected = 1

    result = GeneticAlgorithm.bisect_right(a, x, lo, hi)
    assert expected == result

    a = [1, 2, 3]
    x = 4
    lo = 0
    hi = length(a)
    expected = 3

    result = GeneticAlgorithm.bisect_right(a, x, lo, hi)
    assert expected == result

    a = [2, 6, 7, 9]
    x = 4
    lo = 0
    hi = length(a)
    expected = 1

    result = GeneticAlgorithm.bisect_right(a, x, lo, hi)
    assert expected == result

    a = [1, 3, 4, 4, 4, 6, 7]
    x = 4
    lo = 0
    hi = length(a)
    expected = 5

    result = GeneticAlgorithm.bisect_right(a, x, lo, hi)
    assert expected == result

    a = [14, 26, 45, 50, 77, 85]
    x = 45
    lo = 0
    hi = length(a)
    expected = 3

    result = GeneticAlgorithm.bisect_right(a, x, lo, hi)
    assert expected == result
  end
end
