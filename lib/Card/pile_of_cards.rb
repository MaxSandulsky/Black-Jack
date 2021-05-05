# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require '/home/maxim/NetBeansProjects/Black Jack/lib/Validations/validations.rb'

class PileOfCards
  include Validations
  
  attr_accessor :cards
  
  validate(:var => 'cards', :val => 'array_type', :arg => 'Card')
  
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
  
  def count_value
    total_value = 0
    cards.each do |card|
      total_value += card.value.to_i unless card.value !~ /^\d/
      total_value += 10 unless card.value !~ /^(J|D|K)/
      total_value += 11 unless card.value !~ /^A/
    end
    total_value
  end
  
  def show
    cards.map { |card| card.value if card.explicitness}
  end
  
  def gen_deck(number = 1)
    values = (2..10).to_a
    values += ['J', 'D', 'K', 'A']
    suits = ['♠', '♣', '♥', '♦']
    deck_template = []
    suits.each { |suit| deck_template = deck_template + (values.map { |card| card.to_s + suit.to_s })}
    number.times do
      deck_template.each { |value| self.cards.push(Card.new(value)) }
    end
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
end