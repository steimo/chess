class PlayState < GameState
  # attr_accessor :position, :from, :to
  attr_accessor :board, :from, :to, :first_click

  def initialize(board = Board.new)
    @board = board
    @first_click = true
    board.is_check
    # info
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

  def piece_color(piece)
    /[[:upper:]]/.match(piece) ? 'w' : 'b'
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    GameState.switch(MenuState.instance) if id == Gosu::KbEscape
    return self unless get_idx # check of correct input

    if first_click && get_idx.piece != ' ' && id == Gosu::MsLeft
      @first_click = false
      # find_all_moves <<<<< huge bag here needs refactoring
      @from = get_idx
    elsif id == Gosu::MsRight
      deselect
      @first_click = true
      return self
    elsif id == Gosu::KbU
      $flip == true ? $flip = false : $flip = true
    elsif !first_click && id == Gosu::MsLeft
      @toos = []
      @to = get_idx
      move unless @from.nil? || @to.nil? || @from.piece == ' '
      @first_click = true
    else
      self
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
        all_moves << position if move.can_move && !board.is_check_after_move(position)
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

  def deselect
    board.board.flatten.each do |sq|
      sq.to_selected = false
    end
  end
  
  def move # 'Pe2e4' 'Pe7e8Q'
    position = Position.new(@from, @to)
    move = Move.new(board, position)
    if !move.can_move
      self
    elsif board.is_check_after_move(position)
      self
    else # move.can_move
      nextBoard = @board.move(position)
      $flip == true ? $flip = false : $flip = true
      update_castle_flags(from.x, from.y, to.x, to.y)
      nextPlayState = PlayState.new(nextBoard)
      GameState.switch(nextPlayState)
      $last_move_x = position.to.x
      $last_move_y = position.to.y
    end
  end

  def update_castle_flags(from_x, from_y, _to_x, _to_y)
    piece = board.board[from_y][from_x].piece_str.to_s
    if piece == 'K'
      $can_white_castle_right = false
      $can_white_castle_left = false
    end
    if piece == 'k'
      $can_black_castle_right = false
      $can_black_castle_left = false
    end
    if piece == 'R' && from_x == 0 && from_y == 7 
      $can_white_castle_left = false
    end
    if piece == 'R' && from_x == 7 && from_y == 7 
      $can_white_castle_right = false
    end

    if piece == 'r' && from_x == 0 && from_y == 0 
      $can_black_castle_left = false
    end
    if piece == 'r' && from_x == 7 && from_y == 0 
      $can_black_castle_right = false
    end
  end

  def info # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< temprorary
    if $can_white_castle_right
      puts 'W can castle right'
    else
      puts 'W CANT castle right'
    end
    if $can_white_castle_left 
      puts 'W can castle left'
    else
      puts 'W CANT castle left'
    end
    if $can_black_castle_right
      puts 'B can castle right'
    else
      puts 'B CANT castle right'
    end
    if $can_black_castle_left 
      puts 'B can castle left'
    else
      puts 'B CANT castle left'
    end
    puts '<<<<<<<<<<<<<<<<<<<<<<<'
  end
end
