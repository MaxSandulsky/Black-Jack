# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Deck
  include Validations

  attr_accessor :cards

  validate var: 'cards', val: 'array_type', arg: 'Card'

  def initialize(cards = [])
    self.cards = cards
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

  def generate_cards
    Card::COURTS.each { |court| Card::SUITS.each { |suit| cards.push(Card.new("#{court}#{suit}")) } }
  end
end
