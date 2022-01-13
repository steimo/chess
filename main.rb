require 'gosu'
require_relative 'states/game_state'
require_relative 'states/play_state'
require_relative 'states/menu_state'
require_relative 'states/button'
require_relative 'lib/game'
require_relative 'lib/board'
require_relative 'lib/square'

$window = Game.new
GameState.switch(MenuState.instance)
$window.show
