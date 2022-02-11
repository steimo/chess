require 'singleton'
class MenuState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
   @headline_font = Gosu::Font.new(100, name: 'fonts/unifont-14.0.01.ttf')
    @button_c = Button.new('', 110)
    @button_ng = Button.new('New game', 60)
    @button_l = Button.new('Load game', 0)
    @button_q = Button.new('Quit', -50)
  end

  def update
    update_buttons
  end

  def needs_cursor?
    true
  end

  def draw
    draw_background
    draw_buttons
  end

  def draw_background
    color = Gosu::Color.rgba(238, 238, 210, 255)
    width = $window.width
    $window.draw_quad(0, 0, color, width, 0, color, 0, width, color, width, width, color, z = 1, mode = :default)
    glyph = "♚"
    @headline_font.draw_text(glyph, 20, 700, 10, 1, 1, Gosu::Color::BLACK)
  end

  def draw_buttons
    @button_c.draw_button
    @button_ng.draw_button
    @button_l.draw_button
    @button_q.draw_button
  end

  def update_buttons
    @button_c.update
    @button_ng.update
    @button_l.update
    @button_q.update
  end

  def x_position(text, font)
    x_position = $window.width / 2 - font.text_width(text.to_s) / 2
  end

  def y_position(text, font, shift)
    y_position = $window.height / 2 - font.text_width(text.to_s) / 2 - shift
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    $window.close if @button_q.mouse_over_button && id == Gosu::MsLeft
    GameState.switch(@play_state) if @button_c.mouse_over_button && @play_state
    if @button_ng.mouse_over_button && id == Gosu::MsLeft
      @play_state =  PlayState.new
      @button_c.text = 'Continue'
      GameState.switch(@play_state)
    end
  end
end
