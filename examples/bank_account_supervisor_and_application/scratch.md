# DOING

* make the `BankAccountSupervisor` to use the `BankAccountRegistry` to register new child process

# TODO

* handle the `DOWN` of a registered process so that we can remove from the lookup table
* make the use of `BankAccountRegistry` to be optional when we start a new `BankAccountServer`
* review the way we `create an account` in the `BankServer`, maybe using the API of the `BankAccountSupervisor`
* BUG: every time we delete an account, because of `BankServerSupervisor` a new and orphan `BankAccountServer` will be created.
* BUG: every time a `BankAccountServer` crashes we lose the association between the new `process id` and the bank account `name`
* how can we describe the behaviour of a bank account process that crashes
* what about separate the bank client tests from bank server tests
* understand what the notation `@name` means
* understand how to introduce a sort of storage mechanism (file, database, other) to save the data of the bank account

# DONE

* create a `BankAccountRegistry` in order to register processes with name
* in `bank_account_server` we have not used the `start_link` of the `genserver`
* maybe we can get rid of `start` and `stop` functions of the `BankAccount` client
* just to verify if we can use the notation used for the `BankServer` for the child process `BankAccountSupervisor` in the `BankSupervisor`
* introduce a supervisor for BankAccount processes
* introduce the application so that we can start BankSupervisor as a stand-alone program
* introduce the supervisor
