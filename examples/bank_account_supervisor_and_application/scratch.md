# DOING

# TODO

* understand how to introduce a sort mechanism of storage (file, database, other) to save the data of the bank account

# DONE

* understand what the notation `@name` means
* at the moment the `BankAccountRegistry` and `BankAccountServer` are _coupled_ (Test Doubles)
* can we run the tests in parallel?
* BUG: every time a `BankAccountServer` crashes or it is killed we lose the association between the new `process id` and the bank account `name`
* BUG: every time we delete an account, because of `BankAccountSupervisor` a new and orphan `BankAccountServer` will be created.
* how can we describe the behaviour of a bank account process that crashes
* understand how to deal with the automatic startup of the `application` and our tests
* replace the use of the map in the `BankAccountServer` in favor of the `BankAccountRegistry`
* handle the `DOWN` of a registered process so that we can remove from the lookup table
* make the `BankAccountSupervisor` to use the `BankAccountRegistry` to register new child process
* create a `BankAccountRegistry` in order to register processes with name
* in `bank_account_server` we have not used the `start_link` of the `genserver`
* maybe we can get rid of `start` and `stop` functions of the `BankAccount` client
* just to verify if we can use the notation used for the `BankServer` for the child process `BankAccountSupervisor` in the `BankSupervisor`
* introduce a supervisor for BankAccount processes
* introduce the application so that we can start BankSupervisor as a stand-alone program
* introduce the supervisor
