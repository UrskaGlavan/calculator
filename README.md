# 🧠 Full Plan: Build a Calculator in Elixir (Step-by-Step)

---

## ✅ **Phase 1: Basic Calculator Module (No OTP)**

> Pure Elixir logic — no state, no Phoenix
> 

### Goals:

- Learn Elixir syntax, modules, and pattern matching
- Build simple calculator operations (add, subtract, etc.)
- Add optional memory functions (with a passed-in history)

### Tasks:

- `MyCalc.add(a, b)`
- `MyCalc.sub(a, b)`
- Maybe a module like `MyCalc.Memory` to track history (passed as argument)

✅ **No OTP, no state — just functions**

Create: `nano MyCalc.ex`

```elixir
defmodule MyCalc do
  def add(a, b), do: a + b
  def sub(a, b), do: a - b
  def mul(a, b), do: a * b

  def div(_a, 0), do: {:error, :division_by_zero}
  def div(a, b), do: a / b
end
```

Running it: 

```elixir
iex
c("MyCalc.ex")
```

```elixir
MyCalc.add(5, 3)
# => 8

MyCalc.div(10, 0)
# => {:error, :division_by_zero}

MyCalc.mul(4, 6)
# => 24
```

---

## ✅ **Phase 2: Add OTP (GenServer for memory/history)**

> The calculator becomes stateful
> 

### Goals:

- Learn GenServer
- Keep memory/history inside a process
- Understand how state lives inside Elixir processes

### Tasks:

- Start `CalculatorServer`
- Add `add/2`, `sub/2`, etc. that update state
- Add `store/1`, `clear/0`, `history/0`
- Learn `GenServer.cast` and `GenServer.call`

WHAT IS GenServer?

it is a process that:

- runs in the background
- can hold state
- can handle message
- lives in the BEAM (erlang VM)

We use it when: 

- want to store memory (like a history list)
- respond to commands (add, remove, reset)
- make code concurrent and fault-tolerant ❗
    - concurrent
        - run many pieces of work at the same time
        - this is done with lightweight BEAM processes
        - each process has its own memory, so two tasks can compute wait or sleep independently
    - fault-tolerant
        - if one part crashes, the whole app keeps running
        - this is achieved with with supervisor

What does a GenServer actually do?

- `init` → starts initial state
- `handle_call` → handles synchronous requests (you expect a reply)
- `handle_cast` → handles asynchronous request (you don’t wait for reply)

## Basic structure of every GenServer

1. `use GenServer` → it brings the GenServer behavior and default implementations
    
    ```elixir
    defmodule CalculatorServer do
      use GenServer
    ```
    
2. `start_link/1`
    - starts the process
    
    ```elixir
    def start_link(_opts) do
      GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
    end
    ```
    
    - `__MODULE__`  is the module name (CalculatorServer)
    - `initial_state` is the state you want to start with (usually `[]`, `%{}`, or `0`)
    Must be call before using the server.
3. `init/1` (callback)
    - Called when the GenServer starts
    
    ```elixir
    def init(_args) do
      {:ok, initial_state}
    end
    ```
    
    - Returns `{:ok, state}` — this is the memory the server holds
    - Required callback
4. `handle_call/3` (synchronous)
    - handles requests where the caller expect a response
    
    ```elixir
    def handle_call(:get, _from, state) do
      {:reply, state, state}
    end
    ```
    
    - `:get` → the message
    - `_from` → who asked (you don’t use it here)
    - `state` → current memory of the GenServer
    - returns: `{:reply, result, new_state}`
    
    Required if you use `GenServer.call`
    
5. `handle_cast/2` (asynchronous)
    - handles commands where the caller does not wait for the reply
    
    ```elixir
    def handle_cast(:clear, _state) do
      {:noreply, []}
    end
    ```
    
    - returns: `{:noreply, new_state}`
    
    Required if we use `GenServer.cast`
    
6. Optional helpers → public API functions (custom calls) 
    - these are just functions we define to wrap `call` or `cast`
    
    ```elixir
    def add(a, b), do: GenServer.call(__MODULE__, {:add, a, b})
    def clear_history(), do: GenServer.cast(__MODULE__, :clear)
    ```
    

### CALCULATOR PART:

Create a  new file `touch calculator_server.ex` 

Code:

```elixir
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

  def  handle_call({:div, _a, 0}_from, state) do
    {:reply, {:error, :division_by_zero}, state}
  end

  def handle_call({:div, a, b}, _from, state) do
    result = a / b
    new_state = [{:div, a, b, result} | state]
    {:reply, result, new_state}
  end

  def handle_call(:history, _from, state) do
    {:reply, Enum.reverse(state), state}
  end

  def handle_cast(:clear, _state) do
    {:noreply, []}
  end
end

```

Testing the code:

```elixir
c("calculator_server.ex")
CalculatorServer.start_link(nil)
CalculatorServer.add(2, 3)
CalculatorServer.add(5, 7)
CalculatorServer.history()
CalculatorServer.clear_history()
CalculatorServer.history()
```

### Q:

`_from`

- it is from `handle_call/3`

```elixir
def handle_call(request, from, state)
```

- request → the message sent with `GenServer.call`
- from → who sent the call (process info)
- state → the current internal state of GenServer

So _from is a metadata about who is asking

- `_` prefix means I now the value exists but I am not using it

`|` 

- list cons operator it means: put this item at the front of the list
- this is pushing the newest operation to the front of exiting history list
    - when we are displaying the list we use `Enum.reverse(state)` so the oldest is on the top

### Commit and push

```elixir
git add calculator_server.ex README.md
git commit -m "Phase 2: Add GenServer for calculator state and history"
git push
```

---

## ✅ **Phase 3: Add Phoenix (JSON API)**

> Build a simple REST API to control your calculator
> 

### Goals:

- Create Phoenix app with `-no-html`
- Add `/api/calc/add`, `/api/calc/history`, etc.
- Use your GenServer from controller actions
- Return results as JSON using **Jason**

### Tasks:

- Phoenix controller (CalcController)
- Routes (e.g., `post /api/calc/add`)
- Return JSON with `json(conn, %{result: ...})`

✅ You now understand how Phoenix works as a backend API

---

## ✅ **Phase 4: Add LiveView (Interactive UI)**

> Build a real-time web UI for the calculator
> 

### Goals:

- Add a LiveView page with buttons + input
- Display history live
- Learn how assigns, events, and templates work

### Tasks:

- Create `CalcLive` module
- Add form inputs for numbers
- Handle events like `"add"`, `"clear"`, `"store"`
- Update LiveView via socket assigns

✅ You now understand **LiveView and Phoenix frontend**

---

## ✅ **Phase 5: Add Jason-based persistence**

> Store memory/history in a file (not database yet)
> 

### Goals:

- Save GenServer state to `calc.json` file
- Load it on boot
- Learn Jason, File.read/write, encode/decode

✅ You’ll learn file IO and data serialization in Elixir

---

## ✅ **Phase 6: Add Ecto + Database**

> Store memory/history in a database (Postgres)
> 

### Goals:

- Create Ecto schema for calculations
- Migrate history into DB
- Learn Ecto.Repo, changesets, queries

✅ You now know how to build a **real full-stack Elixir app**

---

## 🔁 Recap of Milestones

| Phase | Tech | Focus |
| --- | --- | --- |
| 1. Calculator (pure) | Elixir only | Functions, pattern matching |
| 2. GenServer | OTP | State, processes |
| 3. Phoenix | Phoenix + Jason | API routes, controllers |
| 4. LiveView | LiveView | UI events, interactivity |
| 5. File Persistence | Jason + File | Serialization |
| 6. Ecto | Database | Schema, Repo, queries |