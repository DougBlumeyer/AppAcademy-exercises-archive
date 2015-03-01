class Player
  attr_accessor :name, :bankroll, :hand, :game, :deck, :turn_taken

  def initialize(game, deck, name, bankroll, hand = [])
    @name = name
    @bankroll = bankroll
    @hand = []
    @game = game
    @deck = deck
    @turn_taken = false
  end

  # def new_cards(cards)
  #   hand.concat(cards)
  # end

  def new_hand
    self.hand = Hand.new(*deck.take(5))
  end

  def hand_value
    hand.points
  end

  def see_ante
    if game.ante > bankroll
      puts "You don't have enough money to see the bet right now. "
      turn_taken = false
    else
      self.bankroll -= game.ante
      game.pot += game.ante
      puts "#{name} sees the ante. The pot is now #{game.pot}"
    end
  end

  def raise_ante
    if game.ante > bankroll
      puts "You don't have enough money to raise the bet right now. "
      turn_taken = false
    else
      bet = 0
      until bet > game.ante
        begin
          print "What do you raise the ante to? "
          bet = Integer(gets.chomp)
        rescue ArgumentError
          puts "Please enter a number."
          retry
        end
        bet = execute_raise(bet)
      end
    end
  end

  def execute_raise(bet)
    if bet <= game.ante
      puts "You've got to actually raise the ante. "
      bet
    else
      if bet > bankroll
        puts "You can't cover that. "
        bet = 0
      else
        puts "#{name} raises the ante to #{bet}. "
        game.ante = bet
        self.bankroll -= bet
        game.pot += bet
        bet = 9999999999999999999999999999
      end
    end
  end

  def take_turn
    turn_taken = false
    render_state
    until turn_taken
      turn_taken = true
      print "#{name}, do you see the ante, raise, or fold? (s/r/f) "
      choice = gets.chomp
      case choice
      when "s"
        see_ante
      when "r"
        raise_ante
      when "f"
        puts "#{name} folds. "
        game.drop_player(self)
      else
        puts "Come again? "
        turn_taken = false
      end
    end
  end

  def switch_cards
    render_state
    switched_count = 0
    print "#{name}, which cards would you like to switch? (e.g. 1,3,4) "
    gets.chomp.split(",").to_a.sort!.reverse!.each do |card_index|
      switched_count += 1
      next if switched_count > 3
      deck.return([hand.cards[card_index.to_i - 1]])
      hand.cards.delete_at(card_index.to_i - 1)
      hand.cards += deck.take(1)
    end
    puts "#{name}'s new hand: #{hand.cards}"
  end

  def get_money(money)
    self.bankroll += money
  end

  def render_state
    puts "\n#{name}'s hand: #{hand.cards}"
    puts "#{name}'s bankroll: #{bankroll}"
    puts "Current ante: #{game.ante}"
    puts "Current pot: #{game.pot}"
  end

end
