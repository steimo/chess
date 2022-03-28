class LoadState < GameState
  attr_accessor :play_state, :order

  def initialize
    @font = Gosu::Font.new(100, name: 'fonts/unifont-14.0.01.ttf')
    @previous = Button.new('< previous', 100, -250, 500)
    @next = Button.new('next >', 100, 250, 500)
    @order = 0
    @saves = create_save_buttons.each_slice(10).to_a
  end

  def update
    update_buttons
  end

  def draw
    MenuState.instance.draw_background
    draw_buttons
  end

  def draw_buttons
    @saves[@order].each do |b|
      b.draw_button unless b.nil?
    end
    @previous.draw_button
    @next.draw_button
  end

  def update_buttons
    @saves[@order].each do |b|
      b.update unless b.nil?
    end
    @previous.update
    @next.update
  end

  def create_save_buttons
    buttons = []
    arr = Dir.children('../chess/saves').sort
    arr.each_slice(10) do |arr|
      arr.each.with_index do |name, i|
        buttons << Button.new(name.to_s.gsub(/[.yml]/, ''), i * 60, 0, 300)
      end
    end
    buttons
  end

  def load_game(name)
    saved = File.open(File.join(Dir.pwd, "../chess/saves/#{name}.yml"), 'r')
    loaded_game = YAML.unsafe_load(saved)
    saved.close
    board = Board.new(PGN::FEN.new(loaded_game.to_s))
    state = PlayState.new(board)
    MenuState.instance.button_c.text = 'Continue'
    GameState.switch(state)
  rescue StandardError => e
    puts e
    self
  end

  def button_down(id)
    GameState.switch(MenuState.instance) if id == Gosu::KbEscape
    @order += 1 if !(@order >= @saves.flatten.size / 11) && (@next.mouse_over_button && id == Gosu::MsLeft)
    @order -= 1 if !(@order <= 0) && (@previous.mouse_over_button && id == Gosu::MsLeft)
    button = @saves.flatten.select(&:mouse_over_button)[0]
    return self if button.nil?

    if id == Gosu::MsLeft && button.mouse_over_button
      load_game(button.text.to_s)
    else
      self
    end
  end
end
