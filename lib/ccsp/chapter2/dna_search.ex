defmodule CCSP.Chapter2.DnaSearch do

  @moduledoc """
  Corresponds to CCSP in Python, Section 2.1, titled "DNA Search"
  """

  @spec char_to_nucleotide(String.t) :: non_neg_integer
  def char_to_nucleotide(nucleotide) do
    cond do
      nucleotide == "A" -> 0
      nucleotide == "C" -> 1
      nucleotide == "G" -> 2
      nucleotide == "T" -> 3
    end
  end

  @spec string_to_gene(String.t) :: list(list(non_neg_integer))
  def string_to_gene(str) do
    str
    |> String.graphemes()
    |> Enum.chunk_every(3, 1, :discard)

  end

  @spec linear_contains?(list(list(non_neg_integer)), list(non_neg_integer)) :: boolean
  def linear_contains?(gene, key_codon) do
    Enum.any?(gene, &(&1 == key_codon))
  end

end