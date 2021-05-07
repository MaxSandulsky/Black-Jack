# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'validations/validations.rb'
require_relative 'card/card.rb'
require_relative 'card/pile_of_cards.rb'
require_relative 'player/player.rb'
require_relative 'dealer/dealer.rb'
require_relative 'game_logic/game_logic.rb'
require_relative 'terminal_interface/terminal_interface.rb'

class Game
  def new_game
    puts 'Enter your name please:'
    @player = Player.new(name: gets.chomp, money: 100, hand: PileOfCards.new)
    newdeck = PileOfCards.new
    newdeck.gen_deck NUMBER_OF_DECKS
    newdeck.mixer!
    @dealer = Dealer.new(money: 100, hand: PileOfCards.new, pile: newdeck)
  end
  
  def cycle
    while @player.bank > 0 && @dealer.bank > 0
      (@dealer.shuffle; puts 'Deck shufled') if @dealer.length < 6
      player_turn
      winner_winner
      hands_wash
    end
    game_start
  end
  
  def player_turn
    puts 'Place your bets!'
    (puts 'Too much'; player_turn) unless bet(gets.to_i) 
    2.times { draw_card }
    show_players_hand
    puts "Press '1' to skip, '2' for more cards, '3' to reveal the cards"
    case gets.to_i
    when 2
      draw_card
      show_players_hand
      dealer_turn
    when 3
      dealer_deal
    else 
      dealer_turn
    end
  rescue RuntimeError => e
    puts e.inspect
  end
  
  def dealer_turn
    dealer_deal
    (@dealer.get_card; @dealer.reveal; show_dealers_hand; states(@dealer)) if @dealer.valuate < 17
  rescue RuntimeError => e
    puts e.inspect
  end
  
  def game_start
    puts "Do you want to play?\n'Y' for Yes, 'N' for No"
    case gets.chomp
    when /Y|y/
      new_game
      cycle
    when /N|n/
      return 0
    else game_start
    end
  end
  
  def show_players_hand
    puts "Your hand:#{@player.show}, value:#{@player.valuate}, money left:#{@player.bank}"
  end
  
  def show_dealers_hand
    puts "Dealers hand:#{@dealer.show}, value:#{@dealer.valuate}, money left:#{@dealer.bank}"
  end
  
  def draw_card
    @player.get_card(@dealer.draw_card)
  end
  
  def dealer_deal
    2.times { @dealer.get_card }
    @dealer.reveal
    show_dealers_hand
    states(@dealer)
  end
  
  def bet(value)
    if @player.bank >= value && @dealer.bank >= value
      @player.bet(value)
      @dealer.keep_bet value
      return true
    end
    false
  end
  
  def hands_wash
    @player.drop_hand
    @dealer.drop_hand
  end
  
  def winner_winner
    if @player.valuate > @dealer.valuate && !@player.looser?
      @player.profit_margin @dealer.release_bet
      puts "#{@player.name} won #{@dealer.release_bet}"
      @dealer.keep_bet 0
    end
    if @player.valuate == @dealer.valuate && !@player.looser?
      @player.profit_margin(@dealer.release_bet/2)
      @dealer.profit_margin(@dealer.release_bet/2)
      @dealer.keep_bet 0
      puts 'It\'s draw!'
    end
    if @player.valuate < @dealer.valuate && !@dealer.looser?
      @dealer.profit_margin @dealer.release_bet
      puts "#{@dealer.name} won #{@dealer.release_bet}"
      @dealer.keep_bet 0
    end
    if @dealer.looser? && !@player.looser?
      @player.profit_margin @dealer.release_bet
      puts "#{@player.name} won #{@dealer.release_bet}"
      @dealer.keep_bet 0
    end
  end
  
  def states(of)
    raise "#{of.name} loose with #{of.show}:( Now #{of.name} have #{of.bank} in bank." if of.looser?
    raise "#{of.name} got Black Jack!!! With #{of.show} Now #{of.name} have #{of.bank + @dealer.release_bet} in bank." if of.black_jack?
  end
end

#g = Game.new
#
#g.game_start

t = TerminalInterface.new
t.start