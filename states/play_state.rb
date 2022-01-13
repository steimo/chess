class PlayState < GameState
  def initialize
    @board = Board.new
  end

  def draw
    @board.draw
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    GameState.switch(MenuState.instance) if id == Gosu::KbEscape
  end
end
