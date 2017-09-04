# BankAccount

A simple project used to get more confidence with [Processes](https://elixir-lang.org/getting-started/processes.html) in Elixir.

We are supposed to write a simple program that allows us to manage bank accounts of our customers. For example we should be able to deposit money, withdrawal money and check our account balance.

## Requirements

* Manage multiple `account`, one for each customer.
* For each account we can perform these actions:
  * create a new account
  * delete an account
  * check current balance
  * deposit money
  * withdrawal money

## What learned

**about map**

If you want to use strings as keys you have to use this forms:

map = %{"my_key" => "my value"}

instead of

map = %{"my_key": "my value"}

because when you use the latter form you get the string "my_key" to be converted in symbolized form `:my_key`

**loading module from iex**

If you want to be able to use modules in iex that are defined in a mix project you can issue this command:

```
iex -S mix
```
