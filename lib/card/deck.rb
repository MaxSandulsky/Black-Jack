# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Deck
  
  attr_accessor :cards
  
  def initialize
    self.cards = []
    generate_cards
    mixer!
  end

  def mixer!
    cards.shuffle!
  end
  
  def generate_cards
    Card::COURTS.each { |court| Card::SUITS.each { |suit| cards.push(Card.new(court, suit)) } }
  end
  
  def draw
    self.cards.pop
  end
end
