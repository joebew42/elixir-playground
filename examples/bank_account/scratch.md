# DOING

# TODO

* separate the client side of the `BankAccount` from the server side
* rename `account_processes` to a more generic `accounts`
* maybe it is better to change the `pid` in something else in `BankAccount`
* update the "what learned" session in the `README.md` by adding "how to skip tests" in Elixir/ExUnit
* maybe should be better to separate the tests of the `Bank` client from the `BankServer` (in other episode)

* what to do when a process dies (introduce a kind of supervisor)

# DONE

* expose a client interface to `BankAccount` (encapsulation) in order to hide details about the message
* maybe the handler for not handled messages can be removed
* decouple the `handle` functions from the `domain logic`
* make the `--trace` option to be the default when executing `mix test`
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
