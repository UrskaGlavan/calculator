defmodule CalcApiWeb.CalcController do
  use CalcApiWeb, :controller

  def add(conn, %{"a" => a, "b" => b}) do
    result = CalculatorServer.add(parse_int(a), parse_int(b))
    json(conn, %{result: result})
  end

  def sub(conn, %{"a" => a, "b" => b}) do
    result = CalculatorServer.sub(parse_int(a), parse_int(b))
    json(conn, %{result: result})
  end

  def mul(conn, %{"a" => a, "b" => b}) do
    result = CalculatorServer.mul(parse_int(a), parse_int(b))
    json(conn, %{result: result})
  end

  def div(conn, %{"a" => a, "b" => b}) do
    result = CalculatorServer.div(parse_int(a), parse_int(b))
    json(conn, %{result: result})
  end

  def history(conn, _params) do
    json(conn, %{history: CalculatorServer.history()})
  end

  def clear_history(conn, _params) do
    CalculatorServer.clear_history()
    send_resp(conn, 204, "")
  end

  defp parse_int(x), do: String.to_integer("#{x}")
end
