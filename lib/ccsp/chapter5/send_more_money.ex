defmodule CCSP.Chapter5.SendMoreMoney do
  alias __MODULE__, as: T

  @moduledoc """
  Corresponds to CCSP in Python, Chapter 5, titled "Genetic Algorithms"
  """

  @type t :: %T{
          letters: list(String.t())
        }

  defstruct [
    :letters
  ]

  @spec new(list(String.t())) :: t
  def new(letters) do
    %T{letters: letters}
  end

  @spec random_instance() :: t
  def random_instance() do
    ["S", "E", "N", "D", "M", "O", "R", "Y", " ", " "]
    |> Enum.shuffle()
    |> new
  end
end

defimpl CCSP.Chapter5.Chromosome, for: CCSP.Chapter5.SendMoreMoney do
  alias CCSP.Chapter5.SendMoreMoney

  @type t :: __MODULE__.t()

  @spec fitness(t) :: float
  def fitness(c) do
    s = Enum.find_index(c.letters, &(&1 == "S"))
    e = Enum.find_index(c.letters, &(&1 == "E"))
    n = Enum.find_index(c.letters, &(&1 == "N"))
    d = Enum.find_index(c.letters, &(&1 == "D"))
    m = Enum.find_index(c.letters, &(&1 == "M"))
    o = Enum.find_index(c.letters, &(&1 == "O"))
    r = Enum.find_index(c.letters, &(&1 == "R"))
    y = Enum.find_index(c.letters, &(&1 == "Y"))

    send = s * 1_000 + e * 100 + n * 10 + d
    more = m * 1_000 + o * 100 + r * 10 + e
    money = m * 10_000 + o * 1_000 + n * 100 + e * 10 + y

    difference = abs(money - (send + more))
    1 / (difference + 1)
  end

  @spec crossover(t, t) :: {t, t}
  def crossover(c1, c2) do
    [idx1, idx2] = Enum.take_random(0..(length(c1.letters) - 1), 2)
    l1 = Enum.at(c1.letters, idx1)
    l2 = Enum.at(c2.letters, idx2)

    new_c1_letters =
      c1.letters
      |> List.replace_at(
        Enum.find_index(c1.letters, &(&1 == l2)),
        Enum.at(c1.letters, idx2)
      )
      |> List.replace_at(idx2, l2)

    new_c2_letters =
      c2.letters
      |> List.replace_at(
        Enum.find_index(c2.letters, &(&1 == l1)),
        Enum.at(c2.letters, idx1)
      )
      |> List.replace_at(idx1, l1)

    {
      %SendMoreMoney{c1 | :letters => new_c1_letters},
      %SendMoreMoney{c2 | :letters => new_c2_letters}
    }
  end

  @spec mutate(t) :: t
  def mutate(c) do
    [idx1, idx2] = Enum.take_random(0..(length(c.letters) - 1), 2)

    c_letters =
      c.letters
      |> List.replace_at(idx1, Enum.at(c.letters, idx2))
      |> List.replace_at(idx2, Enum.at(c.letters, idx1))

    %SendMoreMoney{c | :letters => c_letters}
  end
end

defimpl Inspect, for: CCSP.Chapter5.SendMoreMoney do
  def inspect(c, _opts) do
    s = Enum.find_index(c.letters, &(&1 == "S"))
    e = Enum.find_index(c.letters, &(&1 == "E"))
    n = Enum.find_index(c.letters, &(&1 == "N"))
    d = Enum.find_index(c.letters, &(&1 == "D"))
    m = Enum.find_index(c.letters, &(&1 == "M"))
    o = Enum.find_index(c.letters, &(&1 == "O"))
    r = Enum.find_index(c.letters, &(&1 == "R"))
    y = Enum.find_index(c.letters, &(&1 == "Y"))

    send = s * 1_000 + e * 100 + n * 10 + d
    more = m * 1_000 + o * 100 + r * 10 + e
    money = m * 10_000 + o * 1000 + n * 100 + e * 10 + y

    difference = abs(money - (send + more))

    "#{send} + #{more} = #{money} Difference: #{difference}"
  end
end

defimpl String.Chars, for: CCSP.Chapter5.SendMoreMoney do
  def to_string(c) do
    s = Enum.find_index(c.letters, &(&1 == "S"))
    e = Enum.find_index(c.letters, &(&1 == "E"))
    n = Enum.find_index(c.letters, &(&1 == "N"))
    d = Enum.find_index(c.letters, &(&1 == "D"))
    m = Enum.find_index(c.letters, &(&1 == "M"))
    o = Enum.find_index(c.letters, &(&1 == "O"))
    r = Enum.find_index(c.letters, &(&1 == "R"))
    y = Enum.find_index(c.letters, &(&1 == "Y"))

    send = s * 1_000 + e * 100 + n * 10 + d
    more = m * 1_000 + o * 100 + r * 10 + e
    money = m * 10_000 + o * 1000 + n * 100 + e * 10 + y

    difference = abs(money - (send + more))

    "#{send} + #{more} = #{money} Difference: #{difference}"
  end
end
