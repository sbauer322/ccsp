defmodule CCSP.Chapter2.DnaSearch do

  @moduledoc """
  Corresponds to CCSP in Python, Section 2.1, titled "DNA Search"
  """

  @type nucleotide :: non_neg_integer

  # should only ever have exactly 3 elements
  @type codon :: list(nucleotide)

  @type gene :: list(codon)

  @spec character_to_nucleotide(String.t) :: nucleotide
  defp character_to_nucleotide(nucleotide) do
    uppercase = String.upcase(nucleotide)
    cond do
      uppercase == "A" -> 0
      uppercase == "C" -> 1
      uppercase == "G" -> 2
      uppercase == "T" -> 3
    end
  end

  @spec string_to_nucleotides(String.t) :: list(nucleotide)
  def string_to_nucleotides(str) do
    str
    |> String.graphemes()
    |> Enum.reduce([], &([character_to_nucleotide(&1) | &2]))
  end

  @spec string_to_gene(String.t) :: gene
  def string_to_gene(str) do
    str
    |> string_to_nucleotides()
    |> Enum.chunk_every(3, 1, :discard)
  end

  @spec linear_contains?(gene, codon) :: boolean
  def linear_contains?(gene, codon) do
    gene = string_to_gene(gene)
    codon = string_to_nucleotides(codon)

    Enum.any?(gene, &(&1 == codon))
  end

end