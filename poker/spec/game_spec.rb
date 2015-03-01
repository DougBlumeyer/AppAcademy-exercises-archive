require 'game.rb'

describe Game do
  let(:player_1)  { double("player_1") }
  let(:player_2)  { double("player_2") }
  let(:player_3)  { double("player_3") }
  let(:player_4)  { double("player_4") }

  let(:card_1)    { double("card_1")   }
  let(:card_2)    { double("card_2")   }
  let(:card_3)    { double("card_3")   }
  let(:card_4)    { double("card_4")   }
  let(:card_5)    { double("card_5")   }

  let(:hand)      { double("hand")    }

  subject(:game)  { Game.new }

  context "#initialize" do

    it "starts with player one selected to go first" do
      expect(game.cur_player).to be(game.player_1)
    end

    it "starts with an empty pot" do
      expect(game.pot).to eq(0)
    end

  end

  # context "#round" do
  #
  # end

  context "#begin_round" do

    it "starts with a deck" do
      expect(game.deck).to_not be(nil)
    end

    it "starts with four players" do
      game.begin_round
      expect(game.player_1).to_not be(nil)
      expect(game.player_2).to_not be(nil)
      expect(game.player_3).to_not be(nil)
      expect(game.player_4).to_not be(nil)
    end

    it "creates a hand for each player" #do
      #game.players_in_round = [player_1, player_2, player_3, player_4]
    #   expect(player_1).to receive(:new_hand)
    #   expect(player_2).to receive(:new_hand)
    #   expect(player_3).to receive(:new_hand)
    #   expect(player_4).to receive(:new_hand)
    #   allow(player_1).to receive(:bankroll)
    #   allow(player_2).to receive(:bankroll)
    #   allow(player_3).to receive(:bankroll)
    #   allow(player_4).to receive(:bankroll)
    #   game.begin_round
    # end

    it "resets all players as being in the round" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      expect(game.players_in_round.count).to eq(4)
    end

    it "resets the ante to zero" do
      expect(game.pot).to eq(0)
    end
  end

  context "#phase1" do

    it "increases pot based on player bets" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      allow(player_1).to receive(:bankroll).and_return(100)
      allow(player_1).to receive(:bankroll=) { 10 }
      game.accept_bet(player_1, 90)

      allow(player_2).to receive(:bankroll).and_return(404)
      allow(player_2).to receive(:bankroll=) { 294 }
      game.accept_bet(player_2, 110)
      expect(game.pot).to eq(200)
    end

    it "drops players from the round if they fold" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      game.drop_player(player_3)
      expect(game.players_in_round.count).to eq(3)
    end

    it "updates the current ante" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      allow(player_1).to receive(:bankroll).and_return(1000)
      allow(player_1).to receive(:bankroll=) { 700 }
      game.accept_bet(player_1, 300)
      expect(game.ante).to eq(300)
    end

    it "ends the round if all but one player folds" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      game.drop_player(player_1)
      game.drop_player(player_2)
      allow(player_4).to receive(:bankroll).and_return(100)
      allow(player_4).to receive(:bankroll=) { 10 }
      game.drop_player(player_3)

      expect(game.round_is_over?).to be(true)
    end

    # it "returns money from pot to remaining player if everyone else folds" do
    #   game.players_in_round = [player_1, player_2, player_3, player_4]
    #   game.drop_player(player_1)
    #   game.drop_player(player_2)
    #
    #   allow(player_3).to receive(:bankroll).and_return(100)
    #   allow(player_3).to receive(:bankroll=) { 10 }
    #   game.accept_bet(player_3, 90)
    #
    #   game.drop_player(player_4)
    #   expect(game.pot).to eq(0)
    # end
  end

  context "#accept_bet" do

    it "rejects a bet lower than the ante" do
      expect do
        game.ante = 9000
        game.accept_bet(player_2, 90)
      end.to raise_error("Bet too low!")
    end

    it "takes a number" do
      expect do
        game.accept_bet(player_2, "A")
      end.to raise_error("Numbers only!")
    end
  end

  context "#phase2" do
    # it "allows the players to switch out cards" do
    #   game.switch_cards(player_1, [card_1, card_5])
    #
    #   expect(player_1).to receive(:new_cards)
    # end
    #
    # it "doesn't let players switch more than three cards" do
    #   expect do
    #     game.switch_cards(player_3, [card_1, card_2, card_3, card_4])
    #   end.to raise_error("Can't switch out more than three cards!")
    # end

  end

  context "#phase3" do

    it "increases pot based on player bets" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      allow(player_1).to receive(:bankroll).and_return(100)
      allow(player_1).to receive(:bankroll=) { 10 }
      game.accept_bet(player_1, 90)

      allow(player_2).to receive(:bankroll).and_return(404)
      allow(player_2).to receive(:bankroll=) { 294 }
      game.accept_bet(player_2, 110)
      expect(game.pot).to eq(200)
    end

    it "drops players from the round if they fold" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      game.drop_player(player_3)
      expect(game.players_in_round.count).to eq(3)
    end

    it "updates the current ante" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      allow(player_1).to receive(:bankroll).and_return(1000)
      allow(player_1).to receive(:bankroll=) { 700 }
      game.accept_bet(player_1, 300)
      expect(game.ante).to eq(300)
    end

    it "ends the round if all but one player folds" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      game.drop_player(player_1)
      game.drop_player(player_2)
      allow(player_4).to receive(:bankroll).and_return(100)
      allow(player_4).to receive(:bankroll=) { 10 }
      game.drop_player(player_3)

      expect(game.round_is_over?).to be(true)
    end
  end

  context "#complete round" do

    it "checks for the winner(s) if more than one player remains at the end" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      allow(player_1).to receive(:hand_value).and_return(90)
      allow(player_2).to receive(:hand_value).and_return(140)
      allow(player_3).to receive(:hand_value).and_return(10000)
      allow(player_4).to receive(:hand_value).and_return(1000000)

      expect(game.winners).to eq([player_4])
    end

    it "splits the pot if there's a tie" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      game.pot = 4500

      allow(player_1).to receive(:hand_value).and_return(140)
      allow(player_2).to receive(:hand_value).and_return(140)
      allow(player_3).to receive(:hand_value).and_return(0)
      allow(player_4).to receive(:hand_value).and_return(0)

      expect(player_1).to receive(:get_money) { 2250 }
      expect(player_2).to receive(:get_money) { 2250 }

      game.award_pot

    end

    it "awards money from pot to winner(s)" do
      game.players_in_round = [player_1, player_2, player_3, player_4]
      game.pot = 666

      allow(player_1).to receive(:hand_value).and_return(90)
      allow(player_2).to receive(:hand_value).and_return(140)
      allow(player_3).to receive(:hand_value).and_return(10000)
      allow(player_4).to receive(:hand_value).and_return(1000000)

      expect(player_4).to receive(:get_money) { 666 }

      game.award_pot
    end

  end

end
