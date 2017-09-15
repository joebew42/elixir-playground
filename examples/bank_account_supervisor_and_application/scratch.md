# DOING

# TODO

* what about separate the bank client tests from bank server tests
* how can we describe the behaviour of a bank account process that crashes
* add a monitor for each BankAccount process so that we can update the lookup table when it crash
* understand what the notation `@name` means
* understand how to introduce a sort of storage mechanism (file, database, other) to save the data of the bank account


# DONE

* maybe we can get rid of `start` and `stop` functions of the `BankAccount` client
* just to verify if we can use the notation used for the `BankServer` for the child process `BankAccountSupervisor` in the `BankSupervisor`
* introduce a supervisor for BankAccount processes
* introduce the application so that we can start BankSupervisor as a stand-alone program
* introduce the supervisor
