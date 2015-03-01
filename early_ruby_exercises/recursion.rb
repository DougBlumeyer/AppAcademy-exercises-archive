def range(start_num,end_num)
  return [] if end_num < start_num
  range(start_num,end_num-1) << end_num
end

def sum_iter(arr)
  output = 0
  arr.each { |el| output += el }
  output
end

def sum_rec(arr)
  return arr.first if arr.count == 1
  sum_rec(arr.drop(1)) + arr.first
end

def exp_rec(base,pwr)
  return 1 if pwr == 0
  exp_rec(base,pwr-1) * base
end

def exp_rec_g(base,pwr)
  return base if pwr == 1
  if pwr % 2 == 0
    exp_rec_g(base,pwr/2) * exp_rec_g(base,pwr/2)
  else
    base * exp_rec_g(base,pwr/2) * exp_rec_g(base,pwr/2)
  end
end

class Array
  def deep_dup
    [].tap do |output|
      self.each do |el|
        output << (el.is_a?(Array) ? el.deep_dup : el )
      end
    end
  end
end

def fib_iter(n)
  output = [0,1].take(n)
  (n-2).times { output << output[-1] + output[-2] }
  output
end

def fib_rec(n)
  if n < 3
    [0,1].take(n)
  else
    output = fib_rec(n-1)
    output << output[-1] + output[-2]
  end
end

def bsearch(array, target)
  halfway = array.count/2
  case array[halfway] <=> target
  when 1
    return bsearch(array[0...halfway], target)
  when 0
    return halfway
  when -1
    return halfway + 1 + bsearch(array[halfway+1..-1], target)
  end
  nil
end


def subsets(array)
  if array.empty?
    [[]]
  else
    old_subsets = subsets(array.drop(1))
    new_subsets = []
    old_subsets.each do |old_subset|
      new_subsets << old_subset + [array.first]
    end
    old_subsets + new_subsets
  end
end


if __FILE__ == $PROGRAM_NAME
  # robot_parts = [
  #   ["nuts", "bolts", "washers"],
  #   ["capacitors", "resistors", "inductors"]
  # ]
  #
  # robot_parts_copy = robot_parts.deep_dup
  #
  # # shouldn't modify robot_parts
  # robot_parts_copy[1] << "LEDs"
  # # wtf?
  # puts robot_parts[1] # => ["capacitors", "resistors", "inductors", "LEDs"]
  #
  # bob = [1, [2], [3, [4]]]
  # bob_copy = bob.deep_dup
  # bob_copy[2] << [3,4]
  # p bob[2]
end
