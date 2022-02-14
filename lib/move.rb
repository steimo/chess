class Move
  attr_accessor :board, :position, :fen

  def initialize(board, position)
    @board = board
    @fen = board.fen
    @position = position
  end

  def can_move
    true if can_move_from && can_move_to && can_piece_move
  end

  def can_move_from
    true if piece_color(position.piece_from) == fen.active
  end

  def piece_color(piece)
    /[[:upper:]]/.match(piece) ? 'w' : 'b'
  end

  def can_move_to
    if position.piece_to == '' 
      true
    elsif piece_color(position.piece_to) != fen.active
      true
    else
      false
    end
  end

  def can_piece_move
    true
  end
end
