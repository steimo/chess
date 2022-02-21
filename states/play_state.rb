class PlayState < GameState
  # attr_accessor :position, :from, :to
  attr_accessor :board, :from, :to, :first_click

  def initialize(board = Board.new)
    @board = board
    @first_click = true
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
    if first_click && get_idx.piece != ' ' && id == Gosu::MsLeft
      @first_click = false
      find_all_moves
      @from = get_idx
    elsif !first_click && id == Gosu::MsLeft
      @toos = []
      @to = get_idx
      move unless @from.nil? || @to.nil? || @from.piece == ' '
      @first_click = true
    end
  end

  # def button_up(id)
  #   if id == Gosu::MsLeft
  #     @to = get_idx
  #     move unless @from.nil? || @to.nil? || @from.piece == ' '
  #   end
  # end

  def find_all_moves
    all_moves = []
    all_pieces = @board.yield_pieces
    all_squares_to = @board.yield_squares
    all_pieces.each do |p|
      all_squares_to.each do |to|
        position = Position.new(p.square, to)
        move = Move.new(board, position)
        all_moves << position if move.can_move 
      end
    end
    curently_selected_sq = @board.board.flatten.detect { |m| m.mouse_over_square }
    all_moves.each do |move|
      move.from.selected = true
      @toos = []
      @toos << move if curently_selected_sq.define_position == move.from.define_position
      # puts "#{move.from.piece}#{move.from.define_position}#{move.to.define_position}"
      @toos.map do |to|
        to.to.to_selected = true
      end
    end
  end

  def move # 'Pe2e4' 'Pe7e8Q'
    position = Position.new(@from, @to)
    # print board.is_check_after_move(position)
    move = Move.new(board, position)
    if !move.can_move 
      return self
    elsif board.is_check_after_move(position)
      return self
    else #move.can_move 
      nextBoard = @board.move(position)
      nextPlayState = PlayState.new(nextBoard)
      GameState.switch(nextPlayState)
    end
  end

  def get_piece_at(_x, _y)
    '.'
  end
end
