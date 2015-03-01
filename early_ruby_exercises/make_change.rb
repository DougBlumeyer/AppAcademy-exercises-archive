def make_change(amount, coins)
  biggest_coin = 0
  coins.sort!

  if coins.empty?
    if (amount - biggest_coin) == 0
      coin_counts = []
    else
      raise "Unable to make this biggest_coin with these coins."
    end
  else
    this_coin_count = 0
    until (amount - biggest_coin) < biggest_coin
      biggest_coin += biggest_coin
      this_coin_count += 1
    end
    coin_counts = make_change(amount - biggest_coin, coins[0...-1]).reverse
    coin_counts << this_coin_count
  end

  coin_counts.reverse
end

def make_change_2(amount, coins)
  biggest_coin = 0
  coins.sort!

  if coins.empty?
    if (amount - biggest_coin) == 0
      coin_counts = []
    else
      raise "Unable to make this biggest_coin with these coins."
    end
  else
    if (amount - biggest_coin) >= biggest_coin
      biggest_coin += biggest_coin
      coin_counts = make_change_2(amount - biggest_coin, coins).reverse
      coin_counts[-1] += 1
    else
      coin_counts = make_change_2(amount - biggest_coin, coins[0...-1]).reverse
      coin_counts << 0
    end
  end

  coin_counts.reverse
end

# def make_change_3(amount, coins)
#   biggest_coin = 0
#   coins.sort!
#   least_count = 99999999
#   winning_solution = []
#
#   if coins.empty?
#     if (amount - biggest_coin) == 0
#       coin_counts = []
#       puts "      base case"
#     else
#       raise "Unable to make this biggest_coin with these coins."
#     end
#   else
#     puts "not base case"
#     (0...coins.length).each do |i|
#       puts "  checking #{coins[-1-i]}"
#       if (amount - biggest_coin) >= coins[-1-i]
#         puts "    used a coin"
#         biggest_coin += coins[-1-i]
#         coin_counts = make_change_3(amount - biggest_coin, coins[0..(coins.length-i)]).reverse
#         coin_counts[-1-i] += 1
#       else
#         puts "    didn't use a coin"
#         coin_counts = make_change_3(amount - biggest_coin, coins[0...((coins.length-i)-1)]).reverse
#         coin_counts << 0
#       end
#
#       if coin_counts.inject(:+) < least_count
#         puts "        found a winning solution: #{coin_counts.inject(:+)}"
#         least_count = coin_counts.inject(:+)
#         winning_solution = coin_counts.dup
#       end
#
#     end
#   end
#
#   winning_solution.reverse
# end

def make_change_3(amount, coins)
  coins.sort!
  biggest_coin = coins.last

  if (amount - biggest_coin) == 0
    if coins.empty?
      coin_counts = []
    else
      raise "Unable to make this biggest_coin with these coins."
    end
  else
    if (amount - biggest_coin) >= biggest_coin
      coin_counts = make_change_2(amount - biggest_coin, coins).reverse
      coin_counts[-1] += 1
    else
      coin_counts = make_change_2(amount - biggest_coin, coins[0...-1]).reverse
      coin_counts << 0
    end
  end

  coin_counts.reverse
end
