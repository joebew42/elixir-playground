defmodule Bank.AccountRegistryTest do
  use ExUnit.Case, async: true

  setup do
    start_supervised Bank.AccountRegistry
    %{}
  end

  test "returns undefined when there is no registered process" do
    response = Bank.AccountRegistry.whereis_name("non_registered")

    assert :undefined == response
  end

  test "returns yes if a name is registered correctly" do
    response = Bank.AccountRegistry.register_name("registered", :a_process_id)

    assert :yes == response
  end

  test "returns no if a name is already registered" do
    Bank.AccountRegistry.register_name("process_name", :a_process_id)
    response = Bank.AccountRegistry.register_name("process_name", :a_process_id)

    assert :no == response
  end

  test "returns the process id of a registered process" do
    Bank.AccountRegistry.register_name("registered", :a_process_id)

    response = Bank.AccountRegistry.whereis_name("registered")

    assert :a_process_id == response
  end

  test "the whereis has no side effect on the lookup table" do
    Bank.AccountRegistry.register_name("registered", :a_process_id)
    Bank.AccountRegistry.whereis_name("registered")

    response = Bank.AccountRegistry.whereis_name("registered")

    assert :a_process_id == response
  end

  test "unregister a registered name" do
    Bank.AccountRegistry.register_name("process_name", :a_process_pid)
    Bank.AccountRegistry.unregister_name("process_name")
    response = Bank.AccountRegistry.whereis_name("process_name")

    assert :undefined == response
  end

  test "returns badarg and the message when trying to send a message to a non registered process" do
    response = Bank.AccountRegistry.send("non_registered_process", :a_message)

    assert {:badarg, {"non_registered_process", :a_message}} == response
  end

  test "we are able to send a message to a registered process" do
    Bank.AccountRegistry.register_name("registered_process", self())
    response = Bank.AccountRegistry.send("registered_process", :a_message)

    assert true == is_pid(response)
    assert_received :a_message
  end

  test "when a registered process is killed it will be removed" do
    a_process = spawn fn -> loop() end
    Bank.AccountRegistry.register_name("registered_process", a_process)

    Process.exit(a_process, :kill)
    Process.sleep(200)

    assert :undefined == Bank.AccountRegistry.whereis_name("registered_process")
  end

  def loop() do
    receive do
      _ -> loop()
    end
  end
end
