defmodule SimpleAgentTest do
  use ExUnit.Case, async: true
  doctest SimpleAgent

  test "returns nil when key does not exists" do
    {:ok, agent} = start_supervised SimpleAgent

    assert nil == SimpleAgent.get(agent, "not_existing_key")
  end

  test "store a value in the agent" do
    {:ok, agent} = start_supervised SimpleAgent

    SimpleAgent.put(agent, "key", "value")

    assert "value" == SimpleAgent.get(agent, "key")
  end
end
