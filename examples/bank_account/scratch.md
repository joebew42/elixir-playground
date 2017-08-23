# DOING

* create a new account
  * I'm not able to create a new account if it already exists [DONE]
  * I'm able to create a new account if it not already exists [DOING]
  * Refactor: Look at the `state` of the Bank. We have a `balance` before that the account is created.
    Maybe the `balance` is not a detail of the `Bank` but is a detail of the bank account.
  * Refactor Test: extract bank process in a setup method


# TODO

* delete an account

* each account will be a process, in order to deal with it we have to introduce a way to registry processes with name
* what to do when a process dies (introduce a kind of supervision)

# DONE

* naming tests: rename the term `user` with the term `account`
* withdrawal money
* rename "query" with a more significant name. Maybe we can call it "command", or "call", "action", or "execute", ...
* add a catch-all handler for not handled messages
* think to group tests not by use cases but by starting conditions (ex. account does not exists ...)
* check current account balance
* deposit money
