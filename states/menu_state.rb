require 'singleton'
require 'yaml'
require 'fileutils'

class MenuState < GameState
  include Singleton
  attr_accessor :play_state, :button_c

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

  def create_new_game
    $flip = false
    fen = PGN::FEN.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    board = Board.new(fen)
    @play_state = PlayState.new(board)
    @button_c.text = 'Continue'
    GameState.switch(@play_state)
  end

  def save_game
    filename = Time.now.strftime('%Y-%d-%m %H:%M:%S')
    dirname = File.dirname('chess/saves/')
    FileUtils.mkdir_p('saves') unless File.directory?(dirname)
    return false unless filename

    dump = YAML.dump(@play_state.board.fen)
    File.open(File.join(Dir.pwd, "/saves/#{filename}.yml"), 'w') { |file| file.write dump }
  end

  def button_down(id)
    $window.close if @button_q.mouse_over_button && id == Gosu::MsLeft # quit.
    GameState.switch(@play_state) if @button_c.mouse_over_button && @play_state && id == Gosu::MsLeft # continue.
    save_game if @button_s.mouse_over_button && @play_state && id == Gosu::MsLeft # save.
    if @button_l.mouse_over_button && id == Gosu::MsLeft && !Dir.empty?('../chess/saves') # load.
      GameState.switch(LoadState.new)
    end
    create_new_game if @button_ng.mouse_over_button && id == Gosu::MsLeft # new game creation.
  end
end
