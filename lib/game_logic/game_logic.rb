# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Gamelogic
  RULE_BOOKKEEPING = ->(card) do
    return card.value.to_i unless card.value !~ /^\d/
    return 10 unless card.value !~ /^(J|D|K)/
    return 11 unless card.value !~ /^A/
  end
  
  def initialize(player)
    self.player = player
    self.dealer = Dealer.new( money: 100, hand: PileOfCards.new, pile: PileOfCards.newdeck)
  end
  
  def player_action(action)
    case action
    when 'distribute'
      hands_wash
      2.times { draw }
    when 'draw'
      draw
    when 'reveal'
      reveal
    end
    condition_check
  end
  
  def dealer_action
    2.times { dealer.get_card }
    dealer.get_card if dealer_score < 17
    dealer.reveal
  end
  
  def draw
    player.get_card(dealer.draw_card)
  end
  
  def reveal
    2.times { dealer.get_card }
    dealer.reveal
  end
  
  def player_score
    player.score(RULE_BOOKKEEPING)
  end
  
  def dealer_score
    dealer.score(RULE_BOOKKEEPING)
  end
  
  def hands_wash
    player.drop_hand
    dealer.drop_hand
  end
  
  def condition_check
    return 'Player Black Jack' if player_score == 21
    return 'Dealer Black Jack' if dealer_score == 21
    return 'Player loose' if player_score > 21 || (player_score < dealer_score && dealer_score < 21)
    return 'Player won' if dealer_score > 21 || (player_score > dealer_score && dealer_score > 0)
    return 'Draw' if player_score == dealer_score
    nil
  end
  
  attr_accessor :player, :dealer
end
