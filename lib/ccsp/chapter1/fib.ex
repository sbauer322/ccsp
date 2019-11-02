defmodule CCSP.Chapter1.Fib do
  @moduledoc """
  Corresponds to CCSP in Python, Section 1.1, titled "The Fibonacci Sequence"
  """

  # Infinite recursion example
  #  def fib1(n) do
  #    fib1(n - 1) + fib1(n - 2)
  #  end

  @spec fib2(integer) :: integer
  def fib2(n) when n < 2, do: n

  def fib2(n) do
    fib2(n - 2) + fib2(n - 1)
  end

  # Doesn't actually work or make use of map properly...
  # Better to use GenServer or ETS or memo library
  def fib3(n, memoMap \\ %{0 => 0, 1 => 1}) do
    if Map.get(memoMap, n) == nil do
      (fib3(n - 1, memoMap) + fib3(n - 2, memoMap))
      |> (fn x -> Map.put(memoMap, n, x) end).()
      |> Map.get(n)
    else
      # IO.inspect(memoMap)
      Map.get(memoMap, n)
    end
  end

  @spec fib4(integer, integer) :: integer
  def fib4(n, acc \\ 0) do
    if n < 2 do
      n
    else
      fib2(n - 2) + fib2(n - 1)
    end
  end

  # Generator function... use with Enum.take
  @spec fib6() :: (... -> integer)
  def fib6() do
    Stream.unfold({0, 1}, fn {current, next} ->
      {current, {next, current + next}}
    end)
  end
end
