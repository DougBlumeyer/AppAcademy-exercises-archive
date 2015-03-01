def range(start_num,end_num)
  if end_num < start_num
    arr = []
  else
    arr = range(start_num, end_num-1)
    arr << end_num
  end
  arr
end
