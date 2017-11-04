defmodule GreetingTest do
  use ExUnit.Case, async: true

  test "should returns a greeting" do
    pid = Greeting.start

    response = Greeting.greet(pid)

    assert "hello world" == response
  end

  test "should returns a greeting in spanish" do
    pid = Greeting.start(:spanish)

    response = Greeting.greet(pid)

    assert "hola mundo" == response
  end
end
