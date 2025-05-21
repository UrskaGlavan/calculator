defmodule CalculatorServer do
  use GenServer

  ## Client API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  ## ADD
  def add(a, b) do
    GenServer.call(__MODULE__, {:add, a, b})
  end

  def sub(a,b) do
    GenServer.call(__MODULE__, {:sub, a, b})
  end

  def mul(a,b) do
    GenServer.call(__MODULE__, {:mul, a, b})
  end

  def div(a,b) do
    GenServer.call(__MODULE__, {:div, a, b})
  end

  def history do
    GenServer.call(__MODULE__, :history)
  end

  def clear_history do
    GenServer.cast(__MODULE__, :clear)
  end

  ## Server Callbacks

  def init(_args) do
    {:ok, []}
  end

  ## HANDLE CALL ZA ADD
  def handle_call({:add, a, b}, _from, state) do
    result = a + b
    new_state = [{:add, a, b, result} | state]
    {:reply, result, new_state}
  end

  def handle_call({:sub, a, b}, _from, state) do
    result = a - b
    new_state = [{:sub, a, b, result} | state]
    {:reply, result, new_state}
  end

  def handle_call({:mul, a, b}, _from, state) do
    result = a * b
    new_state = [{:mul, a, b, result} | state]
    {:reply, result, new_state}
  end

  def  handle_call({:div, _a, 0}, _from, state) do
    {:reply, {:error, :division_by_zero}, state}
  end

  def handle_call({:div, a, b}, _from, state) do
    result = a / b
    new_state = [{:div, a, b, result} | state]
    {:reply, result, new_state}
  end


  def handle_call(:history, _from, state) do
    history_as_maps = Enum.map(Enum.reverse(state), fn
      {:add, a, b, result} -> %{
        operation: "add",
        a: a,
        b: b,
        result: result
      }
      {:sub, a, b, result} -> %{
        operation: "sub",
        a: a,
        b: b,
        result: result
      }
      {:mul, a, b, result} -> %{
        operation: "mul",
        a: a,
        b: b,
        result: result
      }
      {:div, a, b, result} -> %{
        operation: "div",
        a: a,
        b: b,
        result: result
      }
    end)

    {:reply, history_as_maps, state}
  end


  def handle_cast(:clear, _state) do
    {:noreply, []}
  end
end
