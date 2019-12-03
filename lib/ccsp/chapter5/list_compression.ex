defmodule CCSP.Chapter5.ListCompression do
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Chapter 5, titled "Genetic Algorithms"

  NOTE: This is very slow to find a solution... along the lines of a couple of hours.

  It does not terminate early and runs through all generations. Maybe an implementation issue?

  One potential solution:

  ["Narine","Melanie","Daniel","Michael","Joshua","Lisa","Dean","Brian","Murat","David","Sajid","Wei","Sarah"]
  """

  @type t :: %T{
               lst: list(any)
             }

  defstruct [
    :lst
  ]

  @people ["Michael", "Sarah", "Joshua", "Narine", "David",
    "Sajid", "Melanie", "Daniel", "Wei", "Dean", "Brian", "Murat", "Lisa"]

  @spec new(list(any)) :: t
  def new(lst) do
    %T{lst: lst}
  end

  @spec random_instance() :: t
  def random_instance() do
    Enum.shuffle(@people)
    |> new()
  end

  @spec bytes_compressed(t) :: non_neg_integer
  def bytes_compressed(lc) do
    lc.lst
    |> :erlang.term_to_binary
    |> :zlib.compress()
    |> byte_size
  end
end

defimpl CCSP.Chapter5.Chromosome, for: CCSP.Chapter5.ListCompression do
  alias CCSP.Chapter5.ListCompression

  @type t :: __MODULE__.t()

  @spec fitness(t) :: float
  def fitness(lc) do
    1 / ListCompression.bytes_compressed(lc)
  end

  @spec crossover(t, t) :: {t, t}
  def crossover(lc1, lc2) do
    [idx1, idx2] = Enum.take_random(0..(length(lc1.lst) - 1), 2)
    l1 = Enum.at(lc1.lst, idx1)
    l2 = Enum.at(lc2.lst, idx2)

    new_lc1_lst =
      lc1.lst
      |> List.replace_at(
           Enum.find_index(lc1.lst, &(&1 == l2)),
           Enum.at(lc1.lst, idx2)
         )
      |> List.replace_at(idx2, l2)

    new_lc2_lst =
      lc2.lst
      |> List.replace_at(
           Enum.find_index(lc2.lst, &(&1 == l1)),
           Enum.at(lc2.lst, idx1)
         )
      |> List.replace_at(idx1, l1)

    {
      %ListCompression{lc1 | :lst => new_lc1_lst},
      %ListCompression{lc2 | :lst => new_lc2_lst}
    }
  end

  @spec mutate(t) :: t
  def mutate(lc) do
    [idx1, idx2] = Enum.take_random(0..(length(lc.lst) - 1), 2)

    new_lst =
      lc.lst
      |> List.replace_at(idx1, Enum.at(lc.lst, idx2))
      |> List.replace_at(idx2, Enum.at(lc.lst, idx1))

    %ListCompression{lc | :lst => new_lst}
  end
end

defimpl Inspect, for: CCSP.Chapter5.ListCompression do
  alias CCSP.Chapter5.ListCompression

  def inspect(lc, _opts) do
    "Order: #{lc.lst} Bytes: #{ListCompression.bytes_compressed(lc)}"
  end
end

defimpl String.Chars, for: CCSP.Chapter5.ListCompression do
  alias CCSP.Chapter5.ListCompression

  def to_string(lc) do
    "Order: #{lc.lst} Bytes: #{ListCompression.bytes_compressed(lc)}"
  end
end
