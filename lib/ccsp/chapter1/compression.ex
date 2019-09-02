defmodule CCSP.Chapter1.Compression do
  import Bitwise, only: :macros

  @moduledoc false

  def compress(gene) do
    String.upcase(gene)
    |> String.graphemes()
    |> Enum.reduce(1, &convert_to_bit/2)
  end

  def decompress(value) do
    # subtract 1 to offset sentinel value during compression
    range = stepped_bit_range(value - 1, 2)

    Enum.reduce(range, "", fn i, acc ->
      bits = value >>> i &&& 3
      convert_to_char(bits, acc)
    end)
    |> String.reverse()
  end

  def convert_to_bit(nucleotide, acc) do
    shiftedAcc = acc <<< 2

    cond do
      nucleotide == "A" -> shiftedAcc ||| 0
      nucleotide == "C" -> shiftedAcc ||| 1
      nucleotide == "G" -> shiftedAcc ||| 2
      nucleotide == "T" -> shiftedAcc ||| 3
    end
  end

  def convert_to_char(bits, acc) do
    cond do
      bits == 0 -> acc <> "A"
      bits == 1 -> acc <> "C"
      bits == 2 -> acc <> "G"
      bits == 3 -> acc <> "T"
    end
  end

  def stepped_bit_range(n, step) do
    half = div(count_bits(n), 2) - 1
    Enum.map(0..half, fn x -> x * step end)
  end

  def count_bits(n, acc \\ 0)

  def count_bits(n, acc) when n > 0 do
    count_bits(n >>> 1, acc + 1)
  end

  def count_bits(_, acc), do: acc
end
