# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Card
  COURTS = %w[J D K A].freeze
  SUITS = ['♠', '♣', '♥', '♦'].freeze

  include Validations

  attr_reader :value, :explicitness

  validate var: 'value', val: 'format', arg: /^(([2-9]|A|K|D|J)|(10))(♠|♣|♥|♦)/

  def initialize(value)
    self.explicitness = false
    self.value = value
    validate!
  end

  def explicit
    self.explicitness = true
  end

  protected

  attr_writer :value, :explicitness
end
