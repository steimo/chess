class PlayState < GameState
  # attr_accessor :position, :from, :to
  attr_accessor :board, :from, :to

  def initialize(board = Board.new)
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
      move unless @from.nil? || @to.nil? || @from.piece == ' '
    end
  end

  def move # 'Pe2e4' 'Pe7e8Q'
    position = Position.new(@from, @to)
    nextBoard = @board.move(position)
    nextPlayState = PlayState.new(nextBoard)
    GameState.switch(nextPlayState)
  end

  def get_piece_at(_x, _y)
    '.'
  end
end
