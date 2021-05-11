# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Dealer < Player
  include Validations

  attr_reader :deck

  validate var: 'name', val: 'type', arg: 'String'
  validate var: 'hand', val: 'type', arg: 'Deck'
  validate var: 'deck', val: 'type', arg: 'Deck'

  def initialize(money:, hand:, deck:)
    self.deck = deck
    super(name: 'Dealer', money: money, hand: hand)
    validate!
  end

  def draw_card
    deck.draw
  end

  def reveal
    hand.cards.each(&:explicit)
  end

  def shuffle
    drop_deck
    self.deck.generate_cards
    deck.mixer!
  end

  def get_card
    hand.add(draw_card)
  end

  def length
    deck.cards.length
  end
  
  def drop_deck
    deck.erase
  end

  protected

  attr_writer :deck
end
