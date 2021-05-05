# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require '/home/maxim/NetBeansProjects/Black Jack/lib/Validations/validations.rb'

class Dealer < Player
  include Validations
  
  attr_reader :pile
  
  validate(:var => 'name', :val => 'type', :arg => 'String')
  validate(:var => 'hand', :val => 'type', :arg => 'PileOfCards')
  validate(:var => 'pile', :val => 'type', :arg => 'PileOfCards')
  
  def initialize(money: 'Money', hand: 'Hand', pile: 'Pile')
    self.pile = pile
    super(:name => 'Dealer', :money => money, :hand => hand)
    validate!
  end
  
  def draw_card
    pile.draw
  end
  
  def reveal
    self.hand.cards.each { |card| card.explicit }
  end
  
  def shuffle
    pile.gen_deck
    pile.mixer!
  end
  
  def get_card
    hand.add(draw_card)
  end
  
  def length
    pile.cards.length
  end
  
  def keep_bet(value)
    bet(value)
    @bet = value * 2
  end
  
  def release_bet
    @bet
  end
  
  protected
  
  attr_writer :pile
end