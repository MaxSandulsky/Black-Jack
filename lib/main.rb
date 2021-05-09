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



# g = Game.new
#
# g.game_start

t = TerminalInterface.new
t.start
