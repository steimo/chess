class PlayState < GameState
  # attr_accessor :position, :from, :to
  attr_accessor :fen, :board, :from, :to

  def initialize(fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', board = Board.new)
    @fen = fen
    @board = board
  end

  def draw
    @board.draw
  end

  def update
    @board.update
  end

  def get_idx # returns square object
     @board.board.flatten.detect { |sq| sq.mouse_over_square }
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    GameState.switch(MenuState.instance) if id == Gosu::KbEscape
    @from = get_idx if id == Gosu::MsLeft
  end

  def button_up(id)
    if id == Gosu::MsLeft
      @to = get_idx
      move unless @from.nil? || @to.nil?
    end
  end

  def move() # 'Pe2e4' 'Pe7e8Q'
    position = Position.new(@from, @to)
    nextBoard = @board.move(position)
    nextPlayState = PlayState.new('safd ', nextBoard)
    GameState.switch(nextPlayState)
  end

  def get_piece_at(_x, _y)
    '.'
  end
end
