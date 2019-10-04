defmodule CCSP.Chapter2.DnaSearchTest do
  require StreamData
  use ExUnitProperties
  use ExUnit.Case
  alias CCSP.Chapter2.DnaSearch
  @moduledoc false

  test "linear search finds expected matches" do
    gene = "ACACACCACACGGGACGAT"
    codon_1 = "ACG"
    codon_2 = "gat"

    assert DnaSearch.linear_contains?(gene, codon_1)
    assert DnaSearch.linear_contains?(gene, codon_2)
  end

  test "linear search finds no matches" do
    gene = "AAAAAAAAAAAAAAAAAA"
    codon_1 = "ACG"
    codon_2 = "gat"

    assert !DnaSearch.linear_contains?(gene, codon_1)
    assert !DnaSearch.linear_contains?(gene, codon_2)
  end

  test "binary search finds expected matches" do
    gene = "ACACACCACACGGGACGAT"
    codon_1 = "ACG"
    codon_2 = "gat"

    assert DnaSearch.binary_contains?(gene, codon_1)
    assert DnaSearch.binary_contains?(gene, codon_2)
  end

  test "binary search finds no matches" do
    gene = "AAAAAAAAAAAAAAAAAA"
    codon_1 = "ACG"
    codon_2 = "gat"

    assert !DnaSearch.binary_contains?(gene, codon_1)
    assert !DnaSearch.binary_contains?(gene, codon_2)
  end
end
