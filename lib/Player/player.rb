# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require '/home/maxim/NetBeansProjects/Black Jack/lib/Validations/validations.rb'

class Player
  include Validations
  
  attr_accessor :name
  attr_reader :bank
  
  validate(:var => 'name', :val => 'type', :arg => 'String')
  validate(:var => 'hand', :val => 'type', :arg => 'PileOfCards')
  
  def initialize(name: 'Name', money: 'Money', hand: 'Hand')
    self.name = name
    profit_margin money
    self.hand = hand
    validate!
  end
  
  def bet(value)
    self.bank -= value
  end
  
  def profit_margin(value)
    self.bank = bank.to_i + value
  end
  
  def get_card(card)
    card.explicit
    hand.add(card)
  end
  
  def drop_hand
    hand.erase
  end
  
  def valuate
    hand.count_value
  end
  
  def show
    hand.show
  end
  
  protected
  
  attr_accessor :hand
  attr_writer :bank
end