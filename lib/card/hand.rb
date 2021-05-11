# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Hand
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

  def drop
    cards.clear
  end
end
