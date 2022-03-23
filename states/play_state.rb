class PlayState < GameState
  attr_accessor :board, :from, :to, :first_click

  def initialize(board = Board.new)
    @board = board
    @first_click = true
    # checks condition that occurs when a player's king is under threat of capture on the opponent's next turn.
    board.is_king_under_check
  end

  def draw
    @board.draw
  end

  def update
    @board.update
    highlight_moves if @first_click
  end

  # returns square object that is curently hovered by mouse.
  def mouseover_sq
    board.board.flatten.detect(&:mouse_over_square)
  end

  def button_down(id)
    return self unless mouseover_sq # makes sure hovered square is not nil.

    GameState.switch(MenuState.instance) if id == Gosu::KbEscape
    if first_click && mouseover_sq.piece != ' ' && id == Gosu::MsLeft
      @first_click = false
      @from = mouseover_sq
      @from.selected = true
    elsif id == Gosu::MsRight
      @first_click = true
      @from.selected = false unless from.nil?
    elsif id == Gosu::KbU # flips the board.
      $flip = !($flip == true)
    elsif !first_click && id == Gosu::MsLeft
      @to = mouseover_sq
      @from.selected = false
      move unless @from.nil? || @to.nil? || @from.piece == ' '
      @first_click = true
    else
      self
    end
  end

  # highlights moves for hovered square.
  def highlight_moves
    from_sq = mouseover_sq
    deselect
    if from_sq.nil?
      deselect
      nil
    else
      board.yield_squares.each do |sq|
        position = Position.new(from_sq, sq)
        move = Move.new(board, position)
        position.to.to_selected = true if move.can_move # && !board.is_check_after_move(position)
      end
    end
  end

  def deselect
    board.board.flatten.each do |sq|
      sq.to_selected = false
    end
  end

  def promotion(board, move, position)
    x = PromotionState.new(board, move, position)
    GameState.switch(x)
  end

  def move
    position = Position.new(@from, @to)
    move = Move.new(board, position)
    if !move.can_move
      self
    elsif board.is_check_after_move(position)
      king = board.find_king
      king.checked = true
      self
    else
      # occurs when the pawn
      # moves to the rank(row) furthest
      # from its starting position and results in promotion state.
      return promotion(board, move, position) if position.to.y == 7 && move.pawn? || position.to.y == 0 && move.pawn?

      next_board = @board.move(position)
      $flip = !($flip == true)
      update_castle_flags(from.x, from.y, to.x, to.y) # checks if neither the king nor the rook has previously moved.
      next_play_state = PlayState.new(next_board)
      GameState.switch(next_play_state)
      $last_move_from_x = position.from.x
      $last_move_from_y = position.from.y
      $last_move_to_x = position.to.x
      $last_move_to_y = position.to.y
      move.check_pawn_attack # checks if an enemy pawn has just moved two squares in a single move and assigns values to the square that the enemy pawn passed.
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
    $can_white_castle_left = false if piece == 'R' && from_x == 0 && from_y == 7
    $can_white_castle_right = false if piece == 'R' && from_x == 7 && from_y == 7

    $can_black_castle_left = false if piece == 'r' && from_x == 0 && from_y == 0
    $can_black_castle_right = false if piece == 'r' && from_x == 7 && from_y == 0
  end
end
