defmodule Calculator  do
  def add(a, b), do: a + b
  def sub(a, b), do: a - b
  def mul(a, b), do: a * b

  def div(_a, 0), do: {:error, :division_by_zero}
  def div(a, b), do: a / b
end
