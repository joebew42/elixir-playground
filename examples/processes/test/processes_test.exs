defmodule ProcessesTest do
  use ExUnit.Case

  defmodule MyProcess do
    def start(language \\ :en) do
      spawn(MyProcess, :loop, [language])
    end

    def greet(pid) do
      send(pid, {self(), :greet})

      receive do
        response -> response
      end
    end

    def loop(language \\ :en) do
      receive do
        {from, :greet} ->
          message =
            case language do
              :es -> "Hola mundo!"
              _ -> "Hello world!"
            end

          send(from, message)
          loop(language)

        _ ->
          loop(language)
      end
    end
  end

  test "run a process" do
    pid = MyProcess.start()

    assert Process.alive?(pid)
  end

  test "returns 'Hello world!' when receive :greet" do
    pid = MyProcess.start()

    response = MyProcess.greet(pid)

    assert response == "Hello world!"
  end

  test "returns 'Hola mundo!' when receive :greet and starts with :es" do
    pid = MyProcess.start(:es)

    response = MyProcess.greet(pid)

    assert response == "Hola mundo!"
  end

  test "process is alive once is started" do
    pid = Processes.start()

    assert true == Process.alive?(pid)
  end

  test "return the current account balance" do
    pid = Processes.start()

    response = Processes.call(pid, {:get, :account_balance})

    assert 1000 == response
  end

  test "deposit 100 will increase the account balance to 1100" do
    pid = Processes.start()
    Processes.call(pid, {:deposit, :account_balance, 100})
    response = Processes.call(pid, {:get, :account_balance})

    assert 1100 == response
  end
end
