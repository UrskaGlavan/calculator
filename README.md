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

✅ You now understand **when and why OTP is useful**

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