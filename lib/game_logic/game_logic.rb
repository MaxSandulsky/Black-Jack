# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Gamelogic
  attr_accessor :player, :dealer, :bet

  RULE_BOOKKEEPING = lambda do |card|
    return card.value.to_i unless card.value !~ /^\d/
    return 10 unless card.value !~ /^(J|D|K)/
    return 11 unless card.value !~ /^A/
  end

  def initialize(player, dealer)
    self.player = player
    self.dealer = dealer
  end

  def player_action(action)
    case action
    when 'distribute'
      hands_wash
      dealer.shuffle if dealer.length < 6
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

  def keep_bets(value)
    player.bet(value)
    dealer.bet(value)
    self.bet = 2 * value
  end

  def condition_check
    return 'Player Black Jack' if player_score == 21
    return 'Dealer Black Jack' if dealer_score == 21
    return 'Player loose' if player_score > 21 || (player_score < dealer_score && dealer_score < 21)
    return 'Player won' if dealer_score > 21 || (player_score > dealer_score && dealer_score > 0)
    return 'Draw' if player_score == dealer_score
    nil
  end

  def result_won
    player.profit_margin(bet)
  end

  def result_loose
    dealer.profit_margin(bet)
  end

  def result_draw
    dealer.profit_margin(bet / 2)
    player.profit_margin(bet / 2)
  end

  def player_bank
    player.bank
  end

  def dealer_bank
    dealer.bank
  end
end
