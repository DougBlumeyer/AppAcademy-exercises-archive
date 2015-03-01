def fib_recur(n)
  if n == 1
    fib_arr = [0]
  elsif n == 2
    fib_arr = [0,1]
  else
    fib_arr = fib_recur(n-1)
    fib_arr << fib_arr[-1] + fib_arr[-2]
  end
  fib_arr
end

def fib_iter(n)
  if n == 1
    fib_arr = [0]
  else
    fib_arr = [0,1]
    (n - 2).times { fib_arr << fib_arr[-1] + fib_arr[-2] }
  end
  fib_arr
end
