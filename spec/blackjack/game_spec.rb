require 'spec_helper'

RSpec.describe Blackjack::Game do
  describe '.new' do
    subject { Blackjack::Game.new options }

    context 'without arguments' do
      let(:options) { {} }

      it { expect(subject.deck.count).to eq 52 - 2 }
      it { expect(subject.deck.first).to be_a_kind_of Blackjack::Card }
      it { expect(subject.dealer.cards.count).to eq 2 }
      it { expect(subject.dealer.cards.first).to be_a_kind_of Blackjack::Card }
      it { expect(subject.dealer).to be_a_kind_of Blackjack::Hand }
    end

    context 'with arguments' do
      let(:options) { {
        deck: [Blackjack::Card.new('hearts', '6')],
        dealer: Blackjack::Hand.new([Blackjack::Card.new('hearts', '7')])
      } }

      it { expect(subject.deck.count).to eq 1 }
      it { expect(subject.deck.first).to be_a_kind_of Blackjack::Card }
      it { expect(subject.dealer.cards.count).to eq 1 }
      it { expect(subject.dealer.cards.first).to be_a_kind_of Blackjack::Card }
    end
  end

  describe '#split' do
    let(:cards) { [Blackjack::Card.new('hearts', '6'), Blackjack::Card.new('spades', '6')] }
    let(:game) { Blackjack::Game.new }
    let(:hand) { Blackjack::Hand.new(cards) }

    subject { game.split(hand) }

    it { expect(subject.count).to eq 2 }
    it { expect(subject.first).to be_a_kind_of Blackjack::Hand }
    it { expect(subject.first.cards.count).to eq 2 }
  end

  describe '#hit' do
    let(:game) { Blackjack::Game.new }
    let(:hand) { Blackjack::Hand.new }
    let!(:deck_count) { game.deck.count }
    before { game.hit(hand) }
    subject { hand }

    it { expect(subject.cards.count).to eq 1 }
    it { expect(subject.cards.first).to be_a_kind_of Blackjack::Card }
    it { expect(game.deck.count).to eq deck_count - 1 }

    context 'when score is much then 21' do
      let(:hand) { Blackjack::Hand.new([Blackjack::Card.new('hearts', 'J'), Blackjack::Card.new('spades', 'Q')]) }

      it { expect(subject.result).to eq 'fail' }
      it { expect(subject.status).to eq 'stand' }
    end
  end

  describe '#select_card' do
    let(:game) { Blackjack::Game.new }

    context 'without options' do
      subject { game.select_card }

      it { expect(subject.count).to eq 1 }
      it { expect(subject).to be_a_kind_of Array }
    end

    context 'with options' do
      let(:count) { 2 }
      subject { game.select_card(count) }

      it { expect(subject.count).to eq count }
      it { expect(subject).to be_a_kind_of Array }
    end
  end

  describe '#boost' do
    let(:game) { Blackjack::Game.new options }
    before { game.boost }
    subject { game.dealer }

    context 'when dealer is less then 17' do
      let(:options) { { dealer: Blackjack::Hand.new([Blackjack::Card.new('spades', '2'), Blackjack::Card.new('spades', '3')]) } }

      it { expect(subject.cards.count).to be > 2 }
    end

    context 'when dealer is more then 17' do
      let(:options) { { dealer: Blackjack::Hand.new([Blackjack::Card.new('spades', '10'), Blackjack::Card.new('spades', 'J')]) } }

      it { expect(subject.cards.count).to eq 2 }
    end

    context 'when deck is empty' do
      let(:options) { {
        dealer: Blackjack::Hand.new([Blackjack::Card.new('spades', '10'), Blackjack::Card.new('spades', 'J')]),
        deck: []
      } }

      it { expect(subject.cards.count).to eq 2 }
    end
  end
end
