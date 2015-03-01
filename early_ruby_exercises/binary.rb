def b_search(arr, target)

  case arr[arr.length/2] <=> target
  when 0
    index = arr.length/2
  when -1
    index = arr.length/2 + 1 + b_search(arr[(arr.length/2) + 1..-1], target)
  when 1
    index = b_search(arr[0...(arr.length/2)], target)
  end

  index
end
