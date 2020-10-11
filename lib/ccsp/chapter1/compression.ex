defmodule CCSP.Chapter1.Compression do
  use Bitwise, only_operators: true

  @moduledoc """
  Corresponds to CCSP in Python, Section 1.2, titled "Trivial Compression"
  """

  @spec compress(String.t()) :: integer
  def compress(gene) do
    String.upcase(gene)
    |> String.graphemes()
    |> Enum.reduce(1, &convert_to_bit/2)
  end

  @spec decompress(integer) :: String.t()
  def decompress(value) do
    # subtract 1 to offset sentinel value during compression
    range = stepped_bit_range(value - 1, 2)

    Enum.reduce(range, "", fn i, acc ->
      bits = value >>> i &&& 3
      convert_to_char(bits, acc)
    end)
    |> String.reverse()
  end

  @spec convert_to_bit(String.t(), integer) :: integer
  def convert_to_bit(nucleotide, acc) do
    shifted_acc = acc <<< 2

    cond do
      nucleotide == "A" -> shifted_acc ||| 0
      nucleotide == "C" -> shifted_acc ||| 1
      nucleotide == "G" -> shifted_acc ||| 2
      nucleotide == "T" -> shifted_acc ||| 3
    end
  end

  @spec convert_to_char(integer, String.t()) :: String.t()
  def convert_to_char(bits, acc) do
    cond do
      bits == 0 -> acc <> "A"
      bits == 1 -> acc <> "C"
      bits == 2 -> acc <> "G"
      bits == 3 -> acc <> "T"
    end
  end

  @spec stepped_bit_range(integer, integer) :: list(integer)
  def stepped_bit_range(n, step) do
    half = div(count_bits(n), 2) - 1
    Enum.map(0..half, fn x -> x * step end)
  end

  @spec count_bits(integer, integer) :: integer
  def count_bits(n, acc \\ 0)

  def count_bits(n, acc) when n > 0 do
    count_bits(n >>> 1, acc + 1)
  end

  def count_bits(_, acc), do: acc
end
