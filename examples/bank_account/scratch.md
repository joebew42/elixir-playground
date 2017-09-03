# DOING

* create a new account


can handle only one account

bank -> accounts -> balance

# TODO

* delete an account

* each account will be a process, in order to deal with it we have to introduce a way to registry processes with name
* what to do when a process dies (introduce a kind of supervision)

# DONE

* remove the `balance` state from the bank
* check the current balance by reading the state of the account instead of the state of the bank
* naming tests: rename the term `user` with the term `account`
* withdrawal money
* rename "query" with a more significant name. Maybe we can call it "command", or "call", "action", or "execute", ...
* add a catch-all handler for not handled messages
* think to group tests not by use cases but by starting conditions (ex. account does not exists ...)
* check current account balance
* deposit money
