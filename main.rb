require 'gosu'
require 'pgn'
require_relative 'states/game_state'
require_relative 'states/game'
require_relative 'states/play_state'
require_relative 'states/promotion.rb'
require_relative 'states/menu_state'
require_relative 'states/button'
require_relative 'lib/board'
require_relative 'lib/square'
require_relative 'lib/position'
require_relative 'lib/move'
$window = Game.new
GameState.switch(MenuState.instance)
$window.show
