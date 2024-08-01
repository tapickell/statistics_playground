defmodule ElixirPython do
  use Export.Python

  @python_dir "lib/python"

  def python_call(file, function, args \\ []) do
    {:ok, pid} = Python.start(python_path: Path.expand(@python_dir))
    data = Python.call(pid, file, function, args)
    Python.close(pid)

    data
  end

  def spawned_hashes() do
    started =
      Time.utc_now()
      |> IO.inspect(label: "Spawned Started")

    Enum.each(0..2, fn n ->
      spawn(fn -> hash_timed(n) end)
    end)

    IO.puts("Spawned SHA256 elapsed #{elapsed(started)}")
  end

  def sequential_hashes() do
    started =
      Time.utc_now()
      |> IO.inspect(label: "Sequential Started")

    Enum.each(0..2, fn n -> hash_timed(n) end)
    IO.puts("Sequential SHA256 elapsed #{elapsed(started)}")
  end

  def hash_timed(n \\ 0) do
    started =
      Time.utc_now()
      |> IO.inspect(label: "#{n} Started")

    Enum.map(0..10, fn i ->
      i
      |> input()
      |> sha256()
      |> IO.inspect(label: "#{n} #{elapsed(started)} sha256")
    end)

    IO.puts("#{n} SHA256 elapsed #{elapsed(started)}")
  end

  defp sha256(binary) do
    :crypto.hash(:sha256, binary)
    |> Base.encode16()
  end

  defp input(i) do
    # this version was slower
    # Stream.cycle([i])
    # |> Enum.take(10_000_000)
    1..10_000_000
    |> Enum.map(fn _ -> i end)
    |> List.to_string()
  end

  defp elapsed(started) do
    Time.diff(Time.utc_now(), started, :second)
  end
end
