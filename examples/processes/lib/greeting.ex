defmodule Greeting do
  def start(language \\ nil) do
    spawn(fn -> loop(language) end)
  end

  def greet(pid) do
    send pid, {self(), :greet}
    receive do
      reply -> reply
    end
  end

  defp loop(language) do
    receive do
      {from_pid, :greet} ->
        send from_pid, greet_message_for(language)
        loop(language)
    end
  end

  defp greet_message_for(language) do
    case language do
      :spanish -> "hola mundo"
      _ -> "hello world"
    end
  end
end
