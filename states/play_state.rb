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
    find_all_moves if id == Gosu::MsRight
  end

  def button_up(id)
    if id == Gosu::MsLeft
      @to = get_idx
      move unless @from.nil? || @to.nil? || @from.piece == ' '
    end
  end

  def find_all_moves
    all_moves = []
    all_pieces = @board.yield_pieces
    all_squares_to = @board.yield_squares
    all_pieces.each do |p|
      all_squares_to.each do |to|
        position = Position.new(p.square, to)
        move = Move.new(board, position)
        if move.can_move
          all_moves << position
        end
      end
    end
    all_moves.each do |move|
      puts "#{move.from.piece}#{move.from.define_position}#{move.to.define_position}"
    end
  end

  def move # 'Pe2e4' 'Pe7e8Q'
    position = Position.new(@from, @to)
    move = Move.new(board, position)
    if move.can_move
      nextBoard = @board.move(position)
      nextPlayState = PlayState.new(nextBoard)
      GameState.switch(nextPlayState)
    end
  end

  def get_piece_at(_x, _y)
    '.'
  end
end
