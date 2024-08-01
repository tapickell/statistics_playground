defmodule AnaylizingData do
  defmodule Summary do
    defstruct [:median, :max, :min, :q1, :q3]
  end

  def plot(set) do
    sorted = Enum.sort(set)
    median = median(sorted)
    min = min(sorted)
    max = max(sorted)
    {q1, _q2, q3, _q4} = quartiles(sorted)
    %Summary{median: median, max: max, min: min, q1: q1, q3: q3}
  end

  def mean([]), do: 0

  def mean(set) do
    n = Enum.count(set)

    Enum.reduce(set, 0, &+/2)
    |> div(n)
  end

  def median(set) do
    n = Enum.count(set)
    sorted = Enum.sort(set)

    case rem(n, 2) do
      1 ->
        i = div(n, 2)
        Enum.at(sorted, i)

      0 ->
        y = div(n, 2)
        x = y - 1

        Enum.slice(sorted, x..y)
        |> mean()
    end
  end

  def mode([]), do: 0

  def mode(set) do
    freqs = Enum.frequencies(set)

    if has_mode?(freqs) do
      freqs
      |> Enum.max(&compare_values/2)
      |> ensure_mode()
    else
      0
    end
  end

  def range(set) do
    sorted = Enum.sort(set)
    x = max(sorted)
    y = min(sorted)
    x - y
  end

  def interquartile_range(set) do
    {lower, upper} = split_on_median(set)
    median(upper) - median(lower)
  end

  defp quartiles(set) do
    {lower, upper} = split_on_median(set)
    q1 = median(lower)
    q2 = max(lower)
    q3 = median(upper)
    q4 = max(upper)

    {q1, q2, q3, q4}
  end

  defp min(set) do
    Enum.at(set, 0)
  end

  defp max(set) do
    n = Enum.count(set)
    Enum.at(set, n - 1)
  end

  defp split_on_median(set) do
    n = Enum.count(set)
    sorted = Enum.sort(set)

    case rem(n, 2) do
      1 ->
        i = div(n, 2)
        lower = Enum.slice(sorted, 0, i)
        upper = Enum.slice(sorted, i + 1, i)
        {lower, upper}

      0 ->
        y = div(n, 2)
        Enum.split(sorted, y)
    end
  end

  defp has_mode?(map) do
    map
    |> Map.values()
    |> Enum.uniq()
    |> Enum.count() > 1
  end

  defp ensure_mode({key, value}) do
    if value == 1 do
      :no_mode
    else
      {key, value}
    end
  end

  defp compare_values({_, v1}, {_, v2}) do
    v1 >= v2
  end

  defp even_count?(set) do
    n = Enum.count(set)
    rem(n, 2) == 0
  end

  defp set_sum(set, acc \\ 0)

  defp set_sum([h | []], acc) do
    acc + h
  end

  defp set_sum([h | tail], acc) do
    h + set_sum(tail, acc)
  end
end
