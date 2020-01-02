defmodule CCSP.Chapter6.KMeans do

  @spec zscores(list) :: list(float)
  def zscores(original) do
    avg = mean(original)
    std = pstdev(original)

    if (std == 0) do
      List.duplicate(0, length(original))
    else
      Enum.map(original, fn x ->
        (x - avg) / std
      end)
    end
  end

  @spec sum(list) :: number
  def sum([]), do: 0

  def sum(list) when is_list(list) do
    Enum.sum(list)
  end

  @spec mean(list) :: number | nil
  def mean(list) when is_list(list) do
    compute_mean(list, 0, 0)
  end

  @spec compute_mean(list, number, integer) :: number | nil
  def compute_mean([], 0, 0), do: nil

  def compute_mean([], sum, index), do: sum / index

  def compute_mean([x | xs] = list, sum, index) do
    compute_mean(xs, sum + x, index + 1)
  end

  @spec variance(list) :: number | nil
  def variance([]) do
    nil
  end

  def variance(list) when is_list(list) do
    population_mean = mean(list)
    list
    |> Enum.map(fn elem ->
      :math.pow(elem - population_mean, 2)
    end)
    |> mean
  end

  @doc """
  Finds the standard deviation of a population
  """
  @spec pstdev(list) :: number | nil
  def pstdev([]) do
    nil
  end

  def pstdev(list) do
    list
    |> variance
    |> :math.sqrt()
  end
end