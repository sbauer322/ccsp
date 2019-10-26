defmodule CCSP.Chapter2.GenericSearchTest do
  require StreamData
  use ExUnitProperties
  use ExUnit.Case
  alias CCSP.Chapter2.GenericSearch
  @moduledoc false

  test "linear search with list of strings" do
    nucleotides = String.graphemes("ACACACCACACGGGACGAT")
    nucleotide = "G"

    assert true == GenericSearch.linear_contains?(nucleotides, nucleotide)
    assert false == GenericSearch.linear_contains?(nucleotides, "Z")
    assert true == GenericSearch.linear_contains?(["cat", "dog", "rain", "potato"], "rain")
  end

  test "linear search with list of tuples" do
    assert true ==
             GenericSearch.linear_contains?([{"c", "a", "t"}, {3, 1, 3}, {"b", "a"}], {"b", "a"})

    assert false == GenericSearch.linear_contains?([{"c", "a", "t"}, {3, 1, 3}, {"b", "a"}], {1})

    assert false ==
             GenericSearch.linear_contains?([{"c", "a", "t"}, {3, 1, 3}, {"b", "a"}], {nil})
  end

  test "linear search with list of numbers" do
    assert true == GenericSearch.linear_contains?([1, 4, 8, 9, 2, 9], 9)
    assert false == GenericSearch.linear_contains?([1, 4, 8, 9, 2, 9], nil)
    assert false == GenericSearch.linear_contains?([1, 4, 8, 9, 2, 9], "a")
    assert false == GenericSearch.linear_contains?([1, 4, 8, 9, 2, 9], 0)
  end
end
