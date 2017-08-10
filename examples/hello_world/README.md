# HelloWorld

**Run tests**

```
mix test
```

## What learned

in order to start a mix (elixir) project:

```
mix new project_name
```

## Two types of tests ?

In Elixir we have `doctest` (maybe unit test) and ExUnit (maybe integration test).

An example of `doctest`

```
defmodule HelloWorld do
  @moduledoc """
  Documentation for HelloWorld.
  """

  @doc """
  Hello world.

  ## Examples

      iex> HelloWorld.hello
      :world

  """
  def hello do
    :world
  end
end
```

An example of ExUnit `test/hello_world_test.exs`

```
defmodule HelloWorldTest do
  use ExUnit.Case
  doctest HelloWorld

  test "the truth" do
    assert 1 + 1 == 2
  end
end
```

the line `doctest HelloWorld` will run doctest present in HelloWorld module. More important, all tests are `.exs` so we don't need to compile before running them.
