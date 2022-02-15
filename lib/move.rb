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
    else
      piece_color(position.piece_to) != fen.active
    end
  end

  def can_piece_move
    piece = position.piece_from.to_s
    from = position.from.define_position
    to = position.to.define_position
    case piece.upcase
    when 'K'
      true if position.abs_delta_x <= 1 && position.abs_delta_y <= 1
    when 'N'
      if position.abs_delta_x == 1 && position.abs_delta_y == 2
        true
      elsif position.abs_delta_x == 2 && position.abs_delta_y == 1
        true
      else
        false
      end
    when 'P'
      true
    end
  end

  def pawn?
    str = position.piece_from
    %w[P p].include?(str)
  end

  def king?
    str = position.piece_from
    %w[K k].include?(str)
  end

  def can_move_straight
    x = position.from.x
    y = position.from.y
    at = position.from
    loop do
      at = Square.new(x + position.sign_x, y + position.sign_y, at.piece)
      true if at == position.to
      break if @board.board[at.x][at.y].piece == ' '
    end
  end

  def to_algebraic_notation_string
    piece = position.piece_from
    piece_str = pawn? ? '' : piece.upcase
    "#{piece_str}#{position.from.define_position}#{position.to.piece == ' ' ? '' : 'x'}#{position.to.define_position}"
  end
end
