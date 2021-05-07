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
    self.cards.push(card)
  end
  
  def del(card)
    self.cards.delete(card)
  end
  
  def count_value(rule)
    total_value = 0
    cards.each do |card|
      total_value += rule.call(card)
    end
    total_value
  end
  
  def show
    cards.map { |card| card.value if card.explicitness}
  end
  
  def erase
    self.cards.clear
  end
  
  def mixer!
    self.cards.shuffle!
  end
  
  def draw
    self.cards.pop
  end
  
  def self.newdeck(number = 1)
    values = (2..10).to_a
    values += Card::COURTS
    deck_template = []
    cards = []
    Card::SUITS.each { |suit| deck_template = deck_template + (values.map { |card| card.to_s + suit.to_s })}
    number.times do
      deck_template.each { |value| cards.push(Card.new(value)) }
    end
    p = PileOfCards.new(cards)
    p.mixer!
    p
  end
end