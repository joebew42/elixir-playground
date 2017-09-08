# DOING

# TODO

* maybe should be better to separate the tests from `Bank` and `BankServer`
* add the `--trace` option to be default when executing `mix test`
* decouple the `handle` functions from the `domain logic`
* expose a client interface to `BankAccount` (encapsulation) in order to hide details about the message
* maybe it is better to change the `pid` in something else in `BankAccount`
* improve the way delete_account is implemented
* update the "what learned" session by adding "how to skip tests"

* what to do when a process dies (introduce a kind of supervisor)

# DONE

* use snake case instead of camel case for functions name
* separate Bank client from Bank server (this will fix collision with function names, see the `server_withdraw`)
* expose a client interface to `Bank` (encapsulation) in order to hide details about the message
* express withdrawal and balance as commands: `withdraw` and `check_balance`
* in `BankAccount` replace conditional with `pattern matching` in the receive block
* {message, new_accounts, new_account_processes} = withdrawal(amount, account, accounts, account_processes) remove the binding
* each account may be a process
* delete an account
* create a new account
* remove the `balance` state from the bank
* check the current balance by reading the state of the account instead of the state of the bank
* naming tests: rename the term `user` with the term `account`
* withdrawal money
* rename "query" with a more significant name. Maybe we can call it "command", or "call", "action", or "execute", ...
* add a catch-all handler for not handled messages
* think to group tests not by use cases but by starting conditions (ex. account does not exists ...)
* check current account balance
* deposit money
