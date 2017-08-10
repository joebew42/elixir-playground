# SimpleAgent

An example of using [agent](https://elixir-lang.org/getting-started/mix-otp/agent.html) and tests.

# What learned

```
use ExUnit.Case, async: true
```

This enable the parallel execution of the tests by taking advantage of all the machine cores.

```
{:ok, agent} = start_supervised SimpleAgent
```

This allows to start the agent as a child of a supervisor. This requires that the module expose a function `child_spec/1` with all the information neeeded to start the child:

```
def child_spec(opts) do
  %{
    id: __MODULE__,
    start: {__MODULE__, :start_link, [opts]},
    type: :worker,
    restart: :permanent,
    shutdown: 500
  }
end
```

or, more easier we can use the already defined `use Agent` or `use GenServer`

**A start_link or whatever must exists**

When we use a supervised process we must give an implementation of the handler specified in the `start` field of the map returned by `child_spec`:

```
def start_link(_opts) do
  Agent.start_link(fn -> %{} end)
end
```

**Capture the function!**

In Elixir we can "capture" function, like so:

```
fun = &List.flatten/2

fun.([1,2,3,[4,5,6]],[7,8,9])

[1,2,3,4,5,6,7,8,9]
```

or we can capture to create new function:

```
flatten_single = &List.flatten(&1, [])

fun.([1,2,3,[4,5,6]])

[1,2,3,4,5,6]
```

or, moreover, these two lines do exactly the same thing:

```
Agent.get(agent, fn(map) -> Map.get(map, key) end)
Agent.get(agent, &Map.get(&1, key))
```
