# DOING



# TODO

* naming tests: rename user with account
* create a new account
* delete an account
* each account will be a process, in order to deal with it we have to introduce a way to registry processes with name
* what to do when a process dies (introduce a kind of supervision)
* take care of the case the server is not able to reply causing client to be stucked

# DONE

* withdrawal money
* rename "query" with a more significant name. Maybe we can call it "command", or "call", "action", or "execute", ...
* add a catch-all handler for not handled messages
* think to group tests not by use cases but by starting conditions (ex. account does not exists ...)
* check current account balance
* deposit money
