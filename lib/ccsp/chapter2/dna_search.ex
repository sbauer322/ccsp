defmodule CCSP.Chapter2.DnaSearch do
  @moduledoc """
  Corresponds to CCSP in Python, Section 2.1, titled "DNA Search"
  """

  @type nucleotide :: non_neg_integer

  # should only ever have exactly 3 elements
  # note that we do not use a tuple like CCSPiP as lists are better suited
  @type codon :: list(nucleotide)

  @type gene :: list(codon)

  @spec character_to_nucleotide(String.t()) :: nucleotide
  defp character_to_nucleotide(nucleotide) do
    nucleotide = String.upcase(nucleotide)

    cond do
      nucleotide == "A" -> 0
      nucleotide == "C" -> 1
      nucleotide == "G" -> 2
      nucleotide == "T" -> 3
    end
  end

  @spec string_to_nucleotides(String.t()) :: list(nucleotide)
  def string_to_nucleotides(str) do
    str
    |> String.graphemes()
    |> Enum.reduce([], &[character_to_nucleotide(&1) | &2])
  end

  @spec string_to_gene(String.t()) :: gene
  def string_to_gene(str) do
    str
    |> string_to_nucleotides()
    |> Enum.chunk_every(3, 1, :discard)
  end

  @spec linear_contains?(String.t(), String.t()) :: boolean
  def linear_contains?(gene, key_codon) do
    gene = string_to_gene(gene)
    codon = string_to_nucleotides(key_codon)

    Enum.any?(gene, &(&1 == codon))
  end

  # need to double check if this function is tail call optimized
  @spec binary_search(gene, codon, non_neg_integer, non_neg_integer) :: boolean
  defp binary_search(gene, key_codon, low, high) when low <= high do
    mid = div(low + high, 2)
    gene_codon = Enum.at(gene, mid)

    cond do
      gene_codon < key_codon -> binary_search(gene, key_codon, mid + 1, high)
      gene_codon > key_codon -> binary_search(gene, key_codon, low, mid - 1)
      true -> true
    end
  end

  defp binary_search(_, _, low, high) when low > high do
    false
  end

  @spec binary_contains?(String.t(), String.t()) :: boolean
  def binary_contains?(gene, key_codon) do
    # must be sorted for binary search to work properly
    sorted_gene = Enum.sort(string_to_gene(gene))
    codon = string_to_nucleotides(key_codon)
    binary_search(sorted_gene, codon, 0, length(sorted_gene) - 1)
  end
end
