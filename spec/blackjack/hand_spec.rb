require 'spec_helper'

RSpec.describe Blackjack::Hand do
  describe '#score' do
    let(:hand) { Blackjack::Hand.new(cards) }

    context 'when pictures' do
      let(:cards) { [Blackjack::Card.new('spades', 'J'), Blackjack::Card.new('spades', 'K')] }
      subject { hand.score }

      it { is_expected.to eq 20 }
    end

    context 'when numbers' do
      let(:cards) { [Blackjack::Card.new('spades', '8'), Blackjack::Card.new('spades', '9')] }
      subject { hand.score }

      it { is_expected.to eq 17 }
    end

    context 'when picture and ase' do
      let(:cards) { [Blackjack::Card.new('spades', 'J'), Blackjack::Card.new('spades', 'A')] }
      subject { hand.score }

      it { is_expected.to eq 21 }
    end

    context 'when pictures and ase' do
      let(:cards) { [Blackjack::Card.new('spades', 'J'), Blackjack::Card.new('spades', 'K'), Blackjack::Card.new('spades', 'A')] }
      subject { hand.score }

      it { is_expected.to eq 21 }
    end
  end
end
