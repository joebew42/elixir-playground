# DOING

# TODO

* review the way we `create an account`, take a look at the responsabilities
* should be better to use `name` instead of `process pid` to identifies `bank_account` processes?
* how can we describe the behaviour of a bank account process that crashes
* add a monitor for each BankAccount process so that we can update the lookup table when it crash
* what about separate the bank client tests from bank server tests
* understand what the notation `@name` means
* understand how to introduce a sort of storage mechanism (file, database, other) to save the data of the bank account


# DONE

* in `bank_account_server` we have not used the `start_link` of the `genserver`
* maybe we can get rid of `start` and `stop` functions of the `BankAccount` client
* just to verify if we can use the notation used for the `BankServer` for the child process `BankAccountSupervisor` in the `BankSupervisor`
* introduce a supervisor for BankAccount processes
* introduce the application so that we can start BankSupervisor as a stand-alone program
* introduce the supervisor
