require 'deck.rb'
require 'card.rb'
require 'hand.rb'
require 'player.rb'

class Game
  attr_reader :deck, :cur_player,
  :player_1, :player_2, :player_3, :player_4, :players_in_round
  attr_accessor :pot, :ante

  def initialize(player_1, player_2, player_3, player_4)
    @deck = Deck.new()
    @player_1, @player_2, @player_3, @player_4 = player_1, player_2, player_3, player_4
    @cur_player = player_1
    @pot = 0
    @players_in_round = [player_1, player_2, player_3, player_4]
    @ante = 0
  end

  def round
    begin_round
    phase_1
    phase_2
    phase_3
    #complete_round
  end

  def begin_round
    players_in_round.each { |player| player.new_hand }
  end

  def phase_1
    players_in_round.each do |player|
      player.take_turn
    end
  end

  def phase_2
    players_in_round.each do |player|
      switch_cards(player)
    end
  end

  def phase_3
    players_in_round.each do |player|
      player.take_turn
    end
  end

  def round_is_over?
    players_in_round.count == 1
  end

  def drop_player(player)
    players_in_round.delete(player)
    complete_round if round_is_over?
  end

  def complete_round
    if players_in_round.count == 1
      players_in_round.last.bankroll += pot
    else
      players_in_round[0].bankroll += pot / 2.0
      players_in_round[1].bankroll += pot / 2.0
    end
    self.pot = 0
  end

  def winning_players
    winning_player = players_in_round.max_by { |player| player.hand_value }
    max_score = winning_player.hand_value

    winning_players = []
    players_in_round.each do |player|
      if player.hand_value == max_score
        winning_players << player
      end
    end

    winning_players
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

  def switch_cards(player)#, disposed_cards)
    #raise "Can't switch out more than three cards!" if disposed_cards.count > 3
  end

  def award_pot
    winning_players.each do |player|
      player.get_money(pot / winning_players.count)
    end
  end

end
