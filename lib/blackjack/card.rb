class Blackjack::Card
  attr_accessor :value, :suit, :visible

  def initialize(suit, value, visible = true)
    @suit = suit
    @value = value
    @visible = visible
  end

  def to_hash
    { suit: @suit, value: @value, visible: @visible }
  end
end
