# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Card
  COURTS = ("2".."10").to_a + ['J', 'D', 'K', 'A',]
  SUITS = %w[♠ ♣ ♥ ♦]

  include Validations

  attr_accessor :value, :suit

  validate var: 'value', val: 'format', arg: /^([2-9]|A|K|D|J)|(10)/
  validate var: 'suit', val: 'format', arg: /(♠|♣|♥|♦)/
  
  def initialize(value, suit)
    self.value = value
    self.suit = suit
    validate!
  end
end
