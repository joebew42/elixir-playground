# BankAccountOTP with supervisor

An example of how we can extend the [BankAccountOTP example](../bank_account_otp/) by introducing the [supervisor and application](https://elixir-lang.org/getting-started/mix-otp/supervisor-and-application.html).

## What learned

[{:name, "joe"}] = [name: "joe"]

## Playing with pipe operator

```
iex(2)> map = %{name: "joe", nickname: "joebew42" }
%{name: "joe", nickname: "joebew42"}
iex(3)> map\
...(3)> |> Enum.find(fn {_name, value} -> value == "joebew42" end)\
...(3)> |> elem(0)
:nickname
iex(4)> map\
...(4)> |> Enum.filter(fn {_name, value} -> value != "joe" end)\
...(4)>
[nickname: "joebew42"]
iex(5)> map\
...(5)> |> Enum.filter(fn {_name, value} -> value != "joe" end)\
...(5)> |> Enum.into(%{})
%{nickname: "joebew42"}
```
