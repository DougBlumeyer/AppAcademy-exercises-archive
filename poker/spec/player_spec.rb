require 'player.rb'

describe Player do

  subject(:player) {Player.new("Evil Doug", 9999999)}

  context "#initialize" do

    it "sets bankroll" do
      expect(player.bankroll).to eq(9999999)
    end

    it "has a name" do
      expect(player.name).to eq("Evil Doug")
    end

    it "has no hand yet" do
      expect(player.hand).to eq([])
    end

  end

end
