class PlayState < GameState
  def initialize
    @message = Gosu::Font.new(100, name: 'fonts/unifont-14.0.01.ttf')
  end

  def draw
    @message.draw_text('PlayState', 200, 200, 10, 1, 1, Gosu::Color::WHITE)
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    GameState.switch(MenuState.instance) if id == Gosu::KbEscape
  end
end
