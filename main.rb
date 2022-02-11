require 'gosu'
require 'pry'
require_relative 'states/game_state'
require_relative 'states/game'
require_relative 'states/play_state'
require_relative 'states/menu_state'
require_relative 'states/button'
require_relative 'lib/chess_helper'
require_relative 'lib/board'
require_relative 'lib/square'
require_relative 'lib/piece'
require_relative 'lib/player'
require_relative 'lib/position'
require_relative 'lib/piece_on_square'
include ChessHelper
$window = Game.new
GameState.switch(MenuState.instance)
$window.show
