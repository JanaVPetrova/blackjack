class Blackjack::Hand
  attr_accessor :cards, :bet, :status, :result

  def initialize(cards = [], bet = 0)
    @cards = cards
    @bet = bet
  end

  def score
    aces = 0
    score = cards.reduce(0) do |sum, card|
      value = card.value
      case value
      when 'A'
        sum += 11
        aces += 1
      when 'K', 'Q', 'J'
        sum += 10
      else
        sum += value.to_i
      end

      sum
    end

    while score > 21 && aces > 0
      score -= 10
      aces -= 1
    end

    score
  end

  def double
    @bet *= 2
  end

  def splitable?
    @cards.map(&:value).uniq.count == 1
  end

  def much?
    score > 21
  end

  def stand
    @status = 'stand'
  end

  def show
    cards.each { |card| card.visible = true }
  end

  def to_hash
    { cards: @cards.map(&:to_hash), bet: @bet, status: @status, result: @result }
  end
end
