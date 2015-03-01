def sum_iterative(arr)
  arr.inject(:+)
end

def sum_recursive(arr)
  arr.length == 1 ? sum = arr[0] : sum = sum_recursive(arr[0...-1]) + arr[-1]
  sum
end
