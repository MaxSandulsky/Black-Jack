# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

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
  
  attr_accessor :exit_status, :game
  
  def new_game
    puts 'Enter your name please:'
    self.game = Gamelogic.new(Player.new(name: gets.chomp, money: 100, hand: PileOfCards.new))
  end
  
  def cycle
    until exit_status
      interface
      results
    end
  rescue RuntimeError => e
    puts e.inspect
  end
  
  def game_state
    'play'
  end
  
  def player_action(action)
    game.player_action(action)
  end
  
  def ask_for_action
    puts 'Press 1, 2, 3'
    case gets.to_i
    when 1
      'draw'
    when 2
      'pass'
    when 3
      'reveal'
    end
  end
  
  def play
    reaction(player_action('distribute'))
    player_score
    reaction(player_action(ask_for_action))
  end
  
  def menu
    
  end
  
  def reaction(state)
    case state
    when 'Player Black Jack'
      raise "You got #{state}"
    when 'Dealer Black Jack'
      raise "You got #{state}"
    when 'Player loose'
      raise "You got #{state}"
    when 'Player won'
      raise "You got #{state}"
    when 'Draw'
      raise "You got #{state}"
    end
  end
  
  def interface
    case game_state
    when 'play'
      play
    when 'menu'
      menu
    end
  end
  
  def player_score
    puts "Your hand:#{game.player.show}, value:#{game.player_score}, money left:#{game.player.bank}"
  end
  
  def dealer_score
    puts "Dealers hand:#{game.dealer.show}, value:#{game.dealer_score}, money left:#{game.dealer.bank}"
  end
  
  def results
    puts "some result"
  end
end
