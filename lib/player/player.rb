# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Player
  include Validations

  attr_accessor :name
  attr_reader :bank

  validate var: 'name', val: 'type', arg: 'String'
  validate var: 'hand', val: 'type', arg: 'Hand'
  validate var: 'bank', val: 'type', arg: 'Integer'

  def initialize(name:, money:, hand:)
    self.name = name
    self.bank = money
    self.hand = hand
    validate!
  end

  def bet(value)
    self.bank -= value
  end

  def profit_margin(value)
    self.bank = bank + value
  end

  def get_card(card)
    hand.add(card)
  end

  def drop_hand
    hand.drop
  end

  def score(rule)
    hand.count_value(rule)
  end

  def on_hands
    hand.cards
  end

  protected

  attr_accessor :hand
  attr_writer :bank
end
