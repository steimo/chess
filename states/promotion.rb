class PromotionState < GameState
  attr_reader :board, :move, :position

  def initialize(board, move, position)
    @board = board
    @move = move
    @position = position
    if $flip
      y = 6
      q = 5
      n = 4
      r = 3
      b = 2
    else
      y = 1
      q = 2
      n = 3
      r = 4
      b = 5
    end
    @square_q = Square.new(q, y, '♕')
    @square_n = Square.new(n, y, '♘')
    @square_r = Square.new(r, y, '♖')
    @square_b = Square.new(b, y, '♗')
  end

  def button_down(id)
    GameState.switch(MenuState.instance) if id == Gosu::KbEscape
    if id == Gosu::MsLeft && @square_q.mouse_over_square
      next_board = make_promote_move('Q')
      switch_to_next_state(next_board)
    elsif id == Gosu::MsLeft && @square_n.mouse_over_square
      next_board = make_promote_move('N')
      switch_to_next_state(next_board)
    elsif id == Gosu::MsLeft && @square_r.mouse_over_square
      next_board = make_promote_move('R')
      switch_to_next_state(next_board)
    elsif id == Gosu::MsLeft && @square_b.mouse_over_square
      next_board = make_promote_move('B')
      switch_to_next_state(next_board)
    end
  end

  def switch_to_next_state(board)
    next_play_state = PlayState.new(board)
    GameState.switch(next_play_state)
  end

  def make_promote_move(piece)
    string = make_string(piece, move)
    position = board.fen.to_position.move(string.strip)
    new = position.to_fen
    $flip = !($flip == true)
    Board.new(new)
  end

  def make_string(piece, move)
    empty = board.square_is_empty?(position.to.x, position.to.y)
    if position.to.y == 7 && move.pawn? && empty || position.to.y == 0 && move.pawn? && empty # if square is empty 
      "#{position.to.define_position}=#{piece}"
    elsif position.to.y == 7 && move.pawn? && !empty || position.to.y == 0 && move.pawn? && !empty # if capture
      "#{position.from.define_position}x#{position.to.define_position}=#{piece}"
    end
  end

  def update
    @square_q.update
    @square_n.update
    @square_r.update
    @square_b.update
  end

  def draw
    MenuState.instance.draw_background
    @square_q.draw
    @square_n.draw
    @square_r.draw
    @square_b.draw
  end
end
