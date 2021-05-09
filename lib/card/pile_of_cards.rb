# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class PileOfCards
  include Validations

  attr_accessor :cards

  validate var: 'cards', val: 'array_type', arg: 'Card'

  def initialize(cards = [])
    self.cards = Array(cards)
    validate!
  end

  def add(card)
    cards.push(card)
  end

  def del(card)
    cards.delete(card)
  end

  def count_value(rule)
    total_value = 0
    cards.each do |card|
      total_value += rule.call(card)
    end
    total_value
  end

  def show
    cards.map { |card| card.value if card.explicitness }
  end

  def erase
    cards.clear
  end

  def mixer!
    cards.shuffle!
  end

  def draw
    cards.pop
  end

  def self.newdeck(number = 1)
    values = (2..10).to_a
    values += Card::COURTS
    deck_template = []
    Card::SUITS.each { |suit| deck_template += (values.map { |card| card.to_s + suit.to_s }) }
    deck = []
    number.times do
      deck_template.each { |value| deck.push(Card.new(value)) }
    end
    PileOfCards.new(deck)
  end
end
