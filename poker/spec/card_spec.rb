require 'card.rb'

describe Card do
  subject(:card) { Card.new(:S, :Q)}

  it "has a suit" do
    expect(card.suit).to_not be(nil)
  end

  it "has a value" do
    expect(card.value).to_not be(nil)
  end

  it "has the correct suit" do
    expect(card.suit).to be(:S)
  end

  it "has the correct value" do
    expect(card.value).to be(:Q)
  end

end
