class Blackjack::Game
  SUITS = %w{diamonds hearts clubs spades}.freeze
  VALUES = ('2'..'10').to_a + %w{J Q K A}.freeze

  attr_accessor :deck, :dealer, :hands

  def initialize(options = {})
    @deck = options[:deck] || new_deck

    @dealer = options[:dealer] || Blackjack::Hand.new(select_card(2))
    @dealer.cards.first.visible = false

    @hands = []
  end

  def split(hand)
    return [hand] unless hand.splitable?

    new_hand = Blackjack::Hand.new(select_card << hand.cards.pop, hand.bet)
    hit(hand)

    [new_hand, hand]
  end

  def hit(hand)
    return hand if hand.score > 21

    hand.cards = hand.cards + select_card

    if hand.score > 21
      hand.result = 'fail'
      hand.stand
    end

    hand
  end

  def select_card(count = 1)
    cards = @deck.sample(count)
    @deck = @deck - cards
    cards
  end

  def over?
    hands.reject { |hand| hand.status == 'stand' }.empty?
  end

  def boost
    while dealer.score < 17
      hit @dealer
    end
  end

  def check
    hands.each do |hand|
      hand.result = if hand.score > 21
        'fail'
      elsif hand.score == dealer.score
        'push'
      elsif hand.score == 21 || dealer.score > 21 || hand.score > dealer.score
        'win'
      else
        'fail'
      end
    end
  end

  def to_hash
    {
      hands: hands.map(&:to_hash),
      dealer: dealer.to_hash,
      deck: deck.map(&:to_hash)
    }
  end

  private

  def new_deck
    SUITS.flat_map { |suit| VALUES.map { |value| Blackjack::Card.new(suit, value) } }
  end
end
