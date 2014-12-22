class Hand
  attr_accessor :cards, :value

  def initialize(card1, card2, card3, card4, card5)
    @cards = [card1, card2, card3, card4, card5]
    @value = 840
  end

  def one_pair
    (0...5).each do |i|
      (i...5).each do |j|
        if cards[i].value == cards[j].value
          return (cards[i].value + cards[j].value) * 4
        end
      end
    end

    0
  end

  def two_pair
    already_paired = nil
    total = 0
    (0...5).each do |i|
      (i + 1...5).each do |j|
        if cards[i].value == cards[j].value && already_paired != cards[i].value
          already_paired = cards[i].value
          total += (cards[i].value + cards[j].value)
        end
      end
    end

    total * 15
  end

  def three_of_a_kind
    (0...5).each do |i|
      (i + 1...5).each do |j|
        (j + 1...5).each do |k|
          if cards[i].value == cards[j].value && cards[j].value == cards[k].value
            return (cards[i].value + cards[j].value + cards[k].value) * 150
          end
        end
      end
    end

    0
  end

  def straight
    cards.sort_by { |card| card.value }
    (0...4).each { |i| return 0 if cards[i].value != cards[i + 1].value - 1 }
    total = 0
    cards.each { |card| total += card.value }

    total * 320
  end

  def flush
    if cards.all? { |card| card.suit == cards[0].suit }
      total = 0
      cards.each { |card| total += card.value }
      return total * 1000
    end

    0
  end

  def full_house
    already_housed = nil
    total = 0

    (0...5).each do |i|
      (i + 1...5).each do |j|
        (j + 1...5).each do |k|
          if cards[i].value == cards[j].value &&
             cards[j].value == cards[k].value &&
             already_housed != cards[i].value
            already_housed = cards[i].value
            total += (cards[i].value + cards[j].value + cards[k].value)
            (0...5).each do |l|
              (l + 1...5).each do |m|
                if cards[l].value == cards[m].value && already_housed != cards[l].value
                  total += (cards[l].value + cards[m].value)
                  return total * 10_000
                end
              end
            end
          end
        end
      end
    end

    0
  end

  def four_of_a_kind
    (0...5).each do |i|
      (i + 1...5).each do |j|
        (j + 1...5).each do |k|
          (k + 1...5).each do |l|
            if cards[i].value == cards[j].value &&
               cards[j].value == cards[k].value &&
               cards[k].value == cards[l].value
              return (cards[i].value + cards[j].value +
                      cards[k].value + cards[l].value) * 60_000
            end
          end
        end
      end
    end

    0
  end

  def straight_flush
    if cards.all? { |card| card.suit == cards[0].suit }
      cards.sort_by { |card| card.value }
      (0...4).each { |i| return 0 if cards[i].value != cards[i + 1].value - 1 }
      total = 0
      cards.each { |card| total += card.value }

      return total * 200_000
    end

    0
  end

  def beats?(other_hand)
    points > other_hand.points
  end

  def points
    return straight_flush  if straight_flush  > 0
    return four_of_a_kind  if four_of_a_kind  > 0
    return full_house      if full_house      > 0
    return flush           if flush           > 0
    return straight        if straight        > 0
    return three_of_a_kind if three_of_a_kind > 0
    return two_pair        if two_pair        > 0
    return one_pair        if one_pair        > 0

    0
  end
end


#
# high card
# 2 - 14
#
# one pair (*4)
# (2+2)*4 = 16
# (14+14)*4 = 112
#
# two pair (*15)
# (2+2)*30 = 120
# (14+14)*30 = 840
#
# three of a kind (*150)
# (2+2+2)*150 = 900
# (14+14+14)*150 = 6_300
#
# straight(*320)
# (2+3+4+5+6)*320 = 6_400
# (14+13+12+11+10)*320 = 19_200
#
# flush(*1000)
# (2+3+4+5+6)*1000 = 20_000
# (14+13+12+11+10)*1000 = 60_000
#
# full house(*10_000)
# (2+2+2)*10_000 = 60_000
# (14+14+14)*10_000 = 420_000
#
# four of a kind(*60_000)
# (2+2+2+2)*60_000 = 480_000
# (14+14+14+14)*60_000 = 3_360_000
#
# straight flush(*200_000)
# (2+3+4+5+6)*200_000 = 4_000_000
# (14+13+12+11+10)*200_000 = 12_000_000
