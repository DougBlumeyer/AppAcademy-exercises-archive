require 'deck.rb'

describe Deck do

  subject(:deck) { Deck.new }

  let(:player_1) { double("player_1") }

  let(:card_1)   { double("card_1")   }
  let(:card_2)   { double("card_2")   }

  let(:game)     { double("game")     }

  context "#initialize" do

    it "has 4 cards of each value" do
      expect(deck.cards.select { |card| card.value == 12}.count).to eq(4)
    end

    it "has 52 cards" do
      expect(deck.cards.count).to eq(52)
    end

    it "has thirteen cards of each suit" do
      expect(deck.cards.select { |card| card.suit == :S}.count).to eq(13)
    end

    it "has a shuffled deck" do
      expect(deck.cards).not_to eq(deck.cards.sort { |card1, card2| card1.value <=> card2.value })
    end

    it "has no duplicate cards" do
      expect(deck.cards).to eq(deck.cards.uniq)
    end
  end

  context "during the game" do

    it "provides cards from its top to players" do
      top_card = deck.cards.first.dup

      allow(player_1).to receive(:hand=)
      deck.deal_hand(player_1)

      expect(deck.cards.first).not_to eq(top_card)
    end

    it "receives cards back from players to its bottom"
    # do
    #   bottom_card = deck.cards.last
    #   allow(deck).to receive(:return) { card_1 }
    #   expect(deck.cards.last).not_to eql(bottom_card)
    # end

    it "shuffles before every round"
    # do
    #   game.begin_round
    #   expect(deck.cards).not_to eq(deck.cards.sort { |card1, card2| card1.value <=> card2.value })
    # end

  end

end
