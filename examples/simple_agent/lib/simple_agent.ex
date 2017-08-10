defmodule SimpleAgent do
  use Agent

  @doc """
  start a new simple agent
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  get the value from a key
  """
  def get(agent, key) do
    Agent.get(agent, &Map.get(&1, key))
  end

  @doc """
  put a new key,value pair in the map
  """
  def put(agent, key, value) do
    Agent.update(agent, &Map.put(&1, key, value))
  end
end
