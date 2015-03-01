def make_change(amount, coins)
  biggest_coin = coins.first

  if amount == 0
    change = []
  elsif coins.empty?
    raise "Unable to make this change with these coins."
  else
    count = 0
    until amount < biggest_coin
      count += 1
      amount -= biggest_coin
    end

    change = make_change(amount, coins.drop(1)).reverse
    count.times { change << biggest_coin }
  end

  change.reverse
end


def make_change_2(amount, coins)
  biggest_coin = coins.first

  if amount == 0
    change = []
  elsif coins.empty?
    raise "Unable to make this change with these coins."
  elsif amount >= biggest_coin
    change = make_change_2(amount - biggest_coin, coins).reverse << biggest_coin
  else
    change = make_change_2(amount, coins.drop(1)).reverse
  end
  change.reverse
end


def make_change_3(amount, coins)

  if amount == 0
    change = []
  elsif coins.empty?
    raise "Unable to make this change with these coins."
  else
    coins.each do |coin|
      if amount >= coin
        comparer = make_change_3(amount - coin, coins)
        if change.nil? || comparer.length < change.length
          change = comparer << coin
        end
      end
    end
  end

  change
end
