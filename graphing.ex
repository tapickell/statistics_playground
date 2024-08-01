defmodule Equation do
  defmodule Quadratic do
    def standard_form({a, b, c}), do: standard_form(a, b, c)

    def standard_form(a, b, c) do
      IO.puts("#{a}x^2 + #{b}x + #{c}")
      fn x -> a * (x * x) + b * x + c end
    end

    def sum_forms(form1, form2), do: combine_forms(form1, form2, &+/2)
    def diff_forms(form1, form2), do: combine_forms(form1, form2, &-/2)

    def mult_forms(form1, form2) do
      f1 = standard_form(form1)
      f2 = standard_form(form2)

      fn x -> f1.(x) * f2.(x) end
    end

    def quot_forms(form1, form2) do
      f1 = standard_form(form1)
      f2 = standard_form(form2)

      fn x -> f1.(x) / f2.(x) end
    end

    def composite(f_list) do
      compose(Enum.reverse(f_list))
    end

    defp compose(list) do
      fn x -> compose(x, list) end
    end

    defp compose(acc, []) do
      acc
    end

    defp compose(acc, [last | rest]) do
      last.(acc)
      |> compose(rest)
    end

    def prod_forms({a1, b1, c1}, {a2, b2, c2}) do
      fourth = a1 * a2
      third = a1 * b2 + b1 * a2
      second = a1 * c2 + b1 * b2 + c1 * a2
      first = b1 * c2 + c1 * b2
      zero = c1 * c2
      IO.puts("#{fourth}x^4 + #{third}x^3 + #{second}x^2 + #{first}x + #{zero}")

      fn x ->
        (fourth * :math.pow(x, 4) + third * :math.pow(x, 3) + second * :math.pow(x, 2) + first * x +
           zero)
        |> trunc()
      end
    end

    defp combine_forms({a1, b1, c1}, {a2, b2, c2}, combinator) do
      a = combinator.(a1, a2)
      b = combinator.(b1, b2)
      c = combinator.(c1, c2)
      standard_form(a, b, c)
    end
  end
end

defmodule Graphing do
  defmodule Parabola do
    alias Equation.Quadratic

    def solve(a, b, c) do
      f = Quadratic.standard_form(a, b, c)

      vx = vx(a, b)
      vy = f.(vx)
      y = f.(0)

      %{y_intercept: {0, y}, vertex: {vx, vy}}
    end

    defp vx(a, b) do
      -(b / (2 * a))
    end
  end

  defmodule Circle do
    def solve(h, k, r_sqrd) do
      r = :math.sqrt(r_sqrd)
    end
  end
end
