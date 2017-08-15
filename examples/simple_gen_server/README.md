# SimpleGenServer

## What learned

* [Naming Conventions](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/pages/Naming%20Conventions.md)
* [ExUnit.Callbacks/start_supervised](https://hexdocs.pm/ex_unit/ExUnit.Callbacks.html#start_supervised/2)


## __MODULE__

`__MODULE__` is a reserved keyword that will replaced with the module name.

## Booleans

`true` and `false`

```
iex(2)> true != false == true
true
```

## Change the format of the console test output

```
mix test --trace
```

## Pattern matching

Original:

```
def handle_call({:create, name}, _from, names) do
  if Map.has_key?(names, name) do
    {:reply, :already_registered, names}
  else
    {:reply, :ok, Map.put(names, name, true)}
  end
end
```

With pattern matching:

```
...
```

## TODO

* Rename SimpleGenServer in RegistryServer
* [Understand how mock/contract works in Elixir](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/)

## Nice to have

* Trying to write a GenServer in Erlang
