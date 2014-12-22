class Player
  attr_accessor :name, :bankroll, :hand

  def initialize(name, bankroll, hand = [])
    @name = name
    @bankroll = bankroll
    @hand = []
  end

  def new_cards(cards)
    hand.concat(cards)
  end

  def take_turn

  end

  def get_money(money)
    self.bankroll += money
  end

end
