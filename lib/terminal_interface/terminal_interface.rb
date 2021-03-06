# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
class GameHandler
  class NotEnoughMoneyError < StandardError; end
end

class TerminalInterface
  def start
    puts "Do you want to play?\n'Y' for Yes, 'N' for No"
    case gets.chomp
    when /Y|y/
      new_game
      cycle
    when /N|n/
      return 0
    else start
    end
  end

  protected

  attr_accessor :exit_status, :game, :game_state

  def new_game
    puts 'Enter your name please:'
    self.game = Gamelogic.new(Player.new(name: gets.chomp, money: 100, hand: Hand.new),
                              Dealer.new(money: 100, hand: Hand.new, deck: Deck.new))
    self.game_state = 'play'
  end

  def cycle
    interface until exit_status
  rescue GameHandler::NotEnoughMoneyError => e
    self.game_state = 'menu'
    puts 'Not enough money!'
    cycle
  end

  def player_action(action)
    game.player_action(action)
  end

  def dealer_action
    game.dealer_action
  end

  def ask_for_action
    puts 'Press 1 to draw, 2 to skip, 3 to reveal'
    case gets.to_i
    when 1
      'draw'
    when 2
      'pass'
    when 3
      'reveal'
    end
  end

  def bets
    puts "You have $#{game.player_bank}, bank have $#{game.dealer_bank}\nMake your bet"
    bet = gets.to_i
    raise GameHandler::NotEnoughMoneyError if game.player_bank < bet || game.dealer_bank < bet
    game.keep_bets(bet)
  end

  def revenue(state)
    case state
    when 'Player Black Jack', 'Player won'
      game.result_won
    when 'Dealer Black Jack', 'Player loose'
      game.result_loose
    when 'Draw'
      game.result_draw
    end
    game.bet
  end

  def play
    reaction(player_action('distribute'))
    player_score
    reaction(player_action(ask_for_action))
    dealer_action
  end

  def menu
    puts 'Want to continue? Y/n'
    case gets.chomp
    when /Y|y/
      self.game_state = 'play'
    when /N|n/
      self.exit_status = true
    end
  end

  def reaction(state)
    raise "You got #{state}" unless state.nil?
  end

  def interface
    case game_state
    when 'play'
      bets
      play
      results
    when 'menu'
      menu
    end
  rescue RuntimeError => e
    results
  end

  def player_score
    puts "Your hand:#{player_hand}, value:#{game.player_score}, left: $#{game.player_bank}"
  end

  def dealer_score
    puts "Dealers hand:#{dealer_hand}, value:#{game.dealer_score}, left: $#{game.dealer_bank}"
  end

  def player_hand
    game.player_hand.map { |card| card.value + card.suit }
  end

  def dealer_hand
    game.dealer_hand.map { |card| card.value + card.suit }
  end

  def results
    puts "#{game.condition_check} $#{game.bet} profit"
    revenue(game.condition_check)
    player_score
    dealer_score
    self.game_state = 'menu'
  end
end
