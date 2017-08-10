defmodule SimpleAgentTest do
  use ExUnit.Case, async: true
  doctest SimpleAgent

  setup do
    {:ok, agent} = start_supervised SimpleAgent
    %{agent: agent}
  end

  test "returns nil when key does not exists", %{agent: agent} do
    assert nil == SimpleAgent.get(agent, "not_existing_key")
  end

  test "store a value in the agent", %{agent: agent} do
    SimpleAgent.put(agent, "key", "value")

    assert "value" == SimpleAgent.get(agent, "key")
  end
end
