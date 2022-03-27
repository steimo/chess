require 'singleton'
require 'yaml'
# require 'marshal'

class MenuState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @font = Gosu::Font.new(100, name: 'fonts/unifont-14.0.01.ttf')
    @button_c = Button.new('', 100)
    @button_ng = Button.new('New game', 50)
    @button_l = Button.new('Load game', 0)
    @button_s = Button.new('Save game', -50)
    @button_q = Button.new('Quit', -150)
  end

  def update
    update_buttons
  end

  def draw
    draw_background
    draw_buttons
  end

  def draw_buttons
    @button_c.draw_button
    @button_ng.draw_button
    @button_l.draw_button
    @button_q.draw_button
    @button_s.draw_button
  end

  def update_buttons
    @button_c.update
    @button_ng.update
    @button_l.update
    @button_q.update
    @button_s.update
  end

  def draw_background
    color = Gosu::Color.rgba(238, 238, 210, 255)
    width = $window.width
    $window.draw_quad(0, 0, color, width, 0, color, 0, width, color, width, width, color, z = 1, mode = :default)
    glyph = '♚'
    @font.draw_text(glyph, define_x(glyph), $window.height - 100, 10, 1, 1, Gosu::Color::BLACK)
  end

  def define_x(text, font = @font)
    $window.width / 2 - font.text_width(text.to_s) / 2
  end

  def save_game
    data = []
    File.open('./saved.yml', 'w') { |f| YAML.dump([] << @play_state.board.fen, f) }
  end

  def load_game
    saved = File.open(File.join(Dir.pwd, './saved.yml'), 'r')
    loaded_game = YAML.unsafe_load(saved)
    saved.close
    board = Board.new(PGN::FEN.new(loaded_game[0].to_s))
    $flip = board.fen == 'w'
    state = PlayState.new(board)
    GameState.switch(state)
  end

  def button_down(id)
    $window.close if @button_q.mouse_over_button && id == Gosu::MsLeft # quit.
    GameState.switch(@play_state) if @button_c.mouse_over_button && @play_state && id == Gosu::MsLeft # continue.
    save_game if @button_s.mouse_over_button && @play_state && id == Gosu::MsLeft # save.
    load_game if @button_l.mouse_over_button && id == Gosu::MsLeft # load.
    if @button_ng.mouse_over_button && id == Gosu::MsLeft # new game creation.
      $flip = false
      fen = PGN::FEN.new('rnbq1bnr/pp1ppppp/8/2B5/K1p5/8/PPPPPkPP/RNBQ2NR w - - 0 1')
      board = Board.new(fen)
      @play_state = PlayState.new(board)
      @button_c.text = 'Continue'
      GameState.switch(@play_state)
    end
  end
end
