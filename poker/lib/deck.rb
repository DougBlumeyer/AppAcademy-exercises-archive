class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    set_deck
  end

  def set_deck
    Card::SUIT_SYMBOLS.each do |suit_key, suit_value|
      Card::VALUES.each do |value_key, value_value|
        cards << Card.new(suit_key, value_value)
      end
    end

    cards.shuffle!
  end

  def deal_hand(player)
    player.hand = cards.shift(5)
  end

  # def switch_cards(player, returned_cards)
  #   player.hand.concat(cards.shift(returned_cards.length))
  #   cards.concat(returned_cards)
  # end

  def take(n)
    cards.shift(n)
  end

  def return(returned_cards)
    returned_cards.each { |returned_card| cards.push(returned_card)}
  end
end
