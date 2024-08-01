defmodule Log do
  def log(2, arg), do: :math.log2(arg)
  def log(10, arg), do: :math.log10(arg)

  def log(base, arg) when base > 1 and arg > 0 do
    num = :math.log(arg)
    den = :math.log(base)
    num / den
  end

  def eval_log(base, arg) when base > arg do
    arg_ex = 1
    base_ex = find_exp(base, arg)
    arg_ex / base_ex
  end

  # this might only work properly if rem(arg, base) == 0
  def find_exp(arg, base, count \\ 1) do
    case div(arg, base) do
      ^base -> count + 1
      not_base -> find_exp(not_base, base, count + 1)
    end
  end
end
