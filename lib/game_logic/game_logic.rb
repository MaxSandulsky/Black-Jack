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
    p = PileOfCards.new
    p.gen_deck
    p.mixer!
    self.dealer = Dealer.new( money: 100, hand: PileOfCards.new, pile: p)
  end
  
  def player_action(action)
    case action
    when 'distribute'
      2.times { draw }
    when 'draw'
      draw
    when 'pass'
      pass
    when 'reveal'
      reveal
    end
    condition_check
  end
  
  def draw
    player.get_card(dealer.draw_card)
  end
  
  def pass
    
  end
  
  def reveal
    
  end
  
  def player_score
    player.score(RULE_BOOKKEEPING)
  end
  
  def dealer_score
    dealer.score(RULE_BOOKKEEPING)
  end
  
  def condition_check
    puts player_score, dealer_score
    return self.condition = 'Player Black Jack' if player_score == 21
    return self.condition = 'Dealer Black Jack' if dealer_score == 21
    return self.condition = 'Player loose' if player_score > 21 || player_score < dealer_score
    return self.condition = 'Player won' if player_score > dealer_score && !dealer_score.zero?
    return self.condition = 'Draw' if player_score == dealer_score
    false
  end
  
  attr_accessor :player, :dealer, :condition
end
