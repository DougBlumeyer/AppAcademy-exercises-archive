def exp_1(base, power)
  power == 0 ? 1 : base * exp_1(base, power-1)
end

def exp_2(base, power)
  if power == 2
    base
  elsif power % 2 == 0
    base * base * exp_1(base, power/2)
  else
    base * base * base * exp_1(base, (power-1)/2)
  end
end

def time_it
  start_time = Time.now
  exp_1(2,256)
  end_time = Time.now
  puts end_time - start_time

  start_time = Time.now
  exp_2(2,256)
  end_time = Time.now
  puts end_time - start_time
end
