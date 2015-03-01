require_relative 'deck.rb'
require_relative 'card.rb'
require_relative 'hand.rb'
require_relative 'player.rb'
require 'pry.rb'

class Game
  attr_reader :deck, :cur_player
  attr_accessor :pot, :ante, :player_1, :player_2, :player_3, :player_4,
                :players_in_round

  def initialize#(player_1, player_2, player_3, player_4)
    @deck = Deck.new()
    #@player_1, @player_2, @player_3, @player_4 = player_1, player_2, player_3, player_4
    @cur_player = player_1
    @pot = 0

    @ante = 0
  end

  def round
    begin_round
    phase_1
    phase_2
    phase_3
    complete_round
  end

  def begin_round
    system("clear")
    self.player_1 = Player.new(self, self.deck, "Doug", 2000)
    self.player_2 = Player.new(self, self.deck, "Lauren", 4000)
    self.player_3 = Player.new(self, self.deck, "Kieran", 1000)
    self.player_4 = Player.new(self, self.deck, "Po", 100_000)
    self.players_in_round = [player_1, player_2, player_3, player_4]
    players_in_round.each { |player| player.new_hand }
  end

  def phase_1
    players_at_start_of_round = players_in_round.dup
    players_at_start_of_round.each do |player|
      break if players_in_round.count == 1
      player.take_turn
    end
  end

  def phase_2
    players_in_round.each do |player|
      break if players_in_round.count == 1
      player.switch_cards
    end
  end

  def phase_3
    players_in_round.each do |player|
      break if players_in_round.count == 1
      player.take_turn
    end
  end

  def round_is_over?
    players_in_round.count == 1
  end

  def drop_player(player)
    players_in_round.delete(player)
  end

  def complete_round
    players_in_round.select! { |player| winners.include?(player) }
    if players_in_round.count == 1
      players_in_round.last.bankroll += pot
      puts "\n#{players_in_round.last.name} wins #{pot}!"
      puts "Their bankroll is now #{players_in_round.last.bankroll}!"
    else
      players_in_round[0].bankroll += pot / 2.0
      players_in_round[1].bankroll += pot / 2.0
      puts "\n#{players_in_round[0].name} and #{players_in_round[1].name} tie!"
      puts "They each win #{pot}."
      puts "#{players_in_round[0].name}'s' bankroll is now #{players_in_round[0].bankroll}!"
      puts "#{players_in_round[1].name}'s' bankroll is now #{players_in_round[1].bankroll}!"
    end
    self.pot = 0
  end

  def winners
    winning_player = players_in_round.max_by { |player| player.hand_value }
    max_score = winning_player.hand_value

    winners = []
    players_in_round.each do |player|
      winners << player if player.hand_value == max_score
    end

    winners
  end

  def accept_bet(player, bet)
    if !bet.is_a?(Integer)
      raise "Numbers only!"
    elsif bet < ante
      raise("Bet too low!")
    else
      self.pot += bet
      self.ante = bet
      player.bankroll -= bet
      player.bankroll = player.bankroll - bet
    end
  end

  # def switch_cards(player)#, disposed_cards)
  #   #raise "Can't switch out more than three cards!" if disposed_cards.count > 3
  # end

  def award_pot
    winners.each { |player| player.get_money(pot / winners.count) }
  end

end

# g = Game.new()
# g.player_1 = Player.new(g, g.deck, "Doug", 100)
# g.player_2 = Player.new(g, g.deck, "Lauren", 100)
# g.player_3 = Player.new(g, g.deck, "Kieran", 100)
# g.player_4 = Player.new(g, g.deck, "Po & Ra", 100)
# g.round
#
# binding.pry

if __FILE__ == $PROGRAM_NAME
  g = Game.new.round
end
