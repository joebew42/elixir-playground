# Anonymous functions

add = fn a, b -> a + b end
double = fn a -> add.(a, a) end

sum = add.(1, 2)
double = double.(2)

IO.puts sum
IO.puts double

x = 42

no_side_effect = (fn -> x = 0 end).()

IO.puts no_side_effect
IO.puts x
