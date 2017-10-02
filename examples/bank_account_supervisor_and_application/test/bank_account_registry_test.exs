defmodule BankAccountRegistryTest do
  use ExUnit.Case, async: true

  setup do
    start_supervised BankAccountRegistry
    %{}
  end

  test "returns undefined when there is no registered process" do
    response = BankAccountRegistry.whereis_name("non_registered")

    assert :undefined == response
  end

  test "returns yes if a name is registered correctly" do
    response = BankAccountRegistry.register_name("registered", :a_process_id)

    assert :yes == response
  end

  test "returns no if a name is already registered" do
    BankAccountRegistry.register_name("process_name", :a_process_id)
    response = BankAccountRegistry.register_name("process_name", :a_process_id)

    assert :no == response
  end

  test "returns the process id of a registered process" do
    BankAccountRegistry.register_name("registered", :a_process_id)

    response = BankAccountRegistry.whereis_name("registered")

    assert :a_process_id == response
  end

  test "the whereis has no side effect on the lookup table" do
    BankAccountRegistry.register_name("registered", :a_process_id)
    BankAccountRegistry.whereis_name("registered")

    response = BankAccountRegistry.whereis_name("registered")

    assert :a_process_id == response
  end

  test "unregister a registered name" do
    BankAccountRegistry.register_name("process_name", :a_process_pid)
    BankAccountRegistry.unregister_name("process_name")
    response = BankAccountRegistry.whereis_name("process_name")

    assert :undefined == response
  end

  test "returns badarg and the message when trying to send a message to a non registered process" do
    response = BankAccountRegistry.send("non_registered_process", :a_message)

    assert {:badarg, {"non_registered_process", :a_message}} == response
  end

  test "we are able to send a message to a registered process" do
    BankAccountRegistry.register_name("registered_process", self())
    response = BankAccountRegistry.send("registered_process", :a_message)

    assert true == is_pid(response)
    assert_received :a_message
  end

  test "when a registered process is killed it will be removed" do
    a_process = spawn fn -> loop() end
    BankAccountRegistry.register_name("registered_process", a_process)

    Process.exit(a_process, :kill)
    Process.sleep(200)

    assert :undefined == BankAccountRegistry.whereis_name("registered_process")
  end

  def loop() do
    receive do
      _ -> loop()
    end
  end
end
