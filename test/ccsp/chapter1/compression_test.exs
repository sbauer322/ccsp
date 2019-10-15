defmodule CCSP.Chapter1.CompressionTest do
  require StreamData
  use ExUnitProperties
  use ExUnit.Case
  alias CCSP.Chapter1.Compression
  @moduledoc false

  def gene_generator() do
    gen all(
          gene <- StreamData.string([?A, ?C, ?G, ?T]),
          gene != ""
        ) do
      gene
    end
  end

  property "raw value matches decompressed value" do
    check all(gene <- gene_generator()) do
      assert Compression.decompress(Compression.compress(gene)) == gene
    end
  end

  test "stepped range" do
    assert Compression.stepped_bit_range(283, 2) == [0, 2, 4, 6]
  end

  test "count bits" do
    assert Compression.count_bits(0) == 0
    assert Compression.count_bits(4) == 3
    assert Compression.count_bits(66) == 7
    assert Compression.count_bits(128) == 8
    assert Compression.count_bits(283) == 9
  end
end
