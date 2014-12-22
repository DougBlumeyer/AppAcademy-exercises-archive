require 'hand.rb'

describe Hand do
  let(:card_1)  { Card.new(:D, 5) }
  let(:card_2)  { Card.new(:H, 5) }
  let(:card_3)  { Card.new(:S, 2) }
  let(:card_4)  { Card.new(:C, 14)}
  let(:card_5)  { Card.new(:D, 14)}
  let(:card_6)  { Card.new(:D, 3) }
  let(:card_7)  { Card.new(:H, 14)}
  let(:card_8)  { Card.new(:C, 4) }
  let(:card_9)  { Card.new(:H, 6) }
  let(:card_10) { Card.new(:H, 8) }
  let(:card_11) { Card.new(:H, 11)}
  let(:card_12) { Card.new(:S, 14)}
  let(:card_13) { Card.new(:H, 7) }
  let(:card_14) { Card.new(:H, 9) }

  let(:hand_1)  { Hand.new(card_1, card_2, card_3,  card_4,  card_6)  } #1 pair
  let(:hand_2)  { Hand.new(card_1, card_2, card_3,  card_4,  card_5)  } #2 pair
  let(:hand_3)  { Hand.new(card_4, card_5, card_7,  card_3,  card_2)  } #3 kind
  let(:hand_4)  { Hand.new(card_3, card_6, card_8,  card_1,  card_9)  } #strght
  let(:hand_5)  { Hand.new(card_2, card_7, card_9,  card_10, card_11) } #flush
  let(:hand_6)  { Hand.new(card_1, card_2, card_4,  card_5,  card_7)  } #fl hs
  let(:hand_7)  { Hand.new(card_4, card_5, card_7,  card_11, card_12) } #4 kind
  let(:hand_8)  { Hand.new(card_2, card_9, card_13, card_10, card_14) } #s flsh
  let(:hand_9)  { Hand.new(card_4, card_5, card_2,  card_3,  card_6)  } #1 pr+

  context "#initialize" do
    it "should have five cards" do
      expect(hand_1.cards.count).to eq(5)
    end

    it "should set its total value correctly" do
      expect(hand_1.value).to eq(840)
    end

  end

  context "evaluating hands" do

    it "should identify a one pair" do
      expect(hand_1.one_pair).to eq(40)
    end

    it "should identify a two pair" do
      expect(hand_2.two_pair).to eq(570)
    end

    it "should identify a three of a kind" do
      expect(hand_3.three_of_a_kind).to eq(6_300)
    end

    it "should should identify a straight" do
      expect(hand_4.straight).to eq(6_400)
    end

    it "should should identify a flush" do
      expect(hand_5.flush).to eq(44_000)
    end

    it "should should identify a full house" do
      expect(hand_6.full_house).to eq(520_000)
    end

    it "should should identify a four of a kind" do
      expect(hand_7.four_of_a_kind).to eq(3_360_000)
    end

    it "should should identify a straight flush" do
      expect(hand_8.straight_flush).to eq(7_000_000)
    end

    it "should recognize within a winning hand type that value ranks winners" do
      expect(hand_9.beats?(hand_1)).to be(true)
    end

    it "ranks the hand types correctly" do
      expect(hand_8.beats?(hand_7)).to be(true)
      expect(hand_7.beats?(hand_6)).to be(true)
      expect(hand_6.beats?(hand_5)).to be(true)
      expect(hand_5.beats?(hand_4)).to be(true)
      expect(hand_4.beats?(hand_3)).to be(true)
      expect(hand_3.beats?(hand_2)).to be(true)
      expect(hand_2.beats?(hand_1)).to be(true)
    end
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
