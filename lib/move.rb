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
    true if position.from.piece_color == fen.active
  end

  def can_move_to
    if position.to.piece_char == ''
      true
    else
      position.to.piece_color != fen.active
    end
  end

  def can_piece_move
    piece = position.from.piece_char
    case piece.upcase
    when 'K'
      if position.abs_delta_x <= 1 && position.abs_delta_y <= 1
        true
      else
        can_castle
      end
    when 'N'
      if position.abs_delta_x == 1 && position.abs_delta_y == 2
        true
      elsif position.abs_delta_x == 2 && position.abs_delta_y == 1
        true
      else
        false
      end
    when 'Q'
      can_move_straight?
    when 'R'
      (position.sign_x == 0 || position.sign_y == 0) && can_move_straight?
    when 'B'
      (position.sign_x != 0 && position.sign_y != 0) && can_move_straight?
    when 'P'
      can_pawn_move
    end
  end

  def can_castle
    from_x = position.from.x
    from_y = position.from.y
    to_x = position.to.x
    to_y = position.to.y
    piece = board.board[from_y][from_x].piece_char
    return can_white_cr if piece == 'K' && from_x == 4 && from_y == 7 && to_x == 6 && to_y == 7
    return can_white_cl if piece == 'K' && from_x == 4 && from_y == 7 && to_x == 2 && to_y == 7
    return can_black_cr if piece == 'k' && from_x == 4 && from_y == 0 && to_x == 6 && to_y == 0
    return can_black_cl if piece == 'k' && from_x == 4 && from_y == 0 && to_x == 2 && to_y == 0

    false
  end

  # checks if king does not pass through a square that is attacked by an enemy piece.
  def king_cell_check(x, y)
    king = board.find_king
    cell = board.board[y][x]
    pos = Position.new(king, cell)
    board.is_check_after_move(pos)
  end

  def can_white_cr
    str_con = board.fen.castling.gsub(/[^[:upper:]]+/, '')
    return false unless str_con[0] == 'K'
    return false if board.king_under_check?
    return false if king_cell_check(5, 7)
    return false unless board.square_is_empty?(5, 7)
    return false unless board.square_is_empty?(6, 7)
    return false if board.board[7][7].piece_char != 'R'

    true
  end

  def can_white_cl
    str_con = board.fen.castling.gsub(/[^[:upper:]]+/, '')
    return false unless str_con == 'KQ' || str_con == 'Q'
    return false if board.king_under_check?
    return false if king_cell_check(3, 7)
    return false unless board.square_is_empty?(3, 7)
    return false unless board.square_is_empty?(2, 7)
    return false unless board.square_is_empty?(1, 7)
    return false if board.board[7][0].piece_char != 'R'

    true
  end

  def can_black_cr
    str_con = board.fen.castling.gsub(/[^[:lower:]]+/, '')
    return false unless str_con[0] == 'k'
    return false if board.king_under_check?
    return false if king_cell_check(5, 0)
    return false unless board.square_is_empty?(5, 0)
    return false unless board.square_is_empty?(6, 0)
    return false if board.board[0][7].piece_char != 'r'

    true
  end

  def can_black_cl
    str_con = board.fen.castling.gsub(/[^[:lower:]]+/, '')
    return false unless str_con == 'kq' || str_con == 'q'
    return false if board.king_under_check?
    return false if king_cell_check(3, 0)
    return false unless board.square_is_empty?(3, 0)
    return false unless board.square_is_empty?(2, 0)
    return false unless board.square_is_empty?(1, 0)
    return false if board.board[0][0].piece_char != 'r'

    true
  end

  def pawn?
    str = position.from.piece_char
    %w[P p].include?(str)
  end

  def king?
    str = position.from.piece_char
    %w[K k].include?(str)
  end

  def can_pawn_move
    if position.from.y > 6 || position.from.y < 1
      false
    else
      step_y = position.from.piece_color == 'w' ? -1 : 1
      can_pawn_go(step_y) || can_pawn_jump(step_y) || can_pawn_eat(step_y) || en_passant
    end
  end

  def en_passant
    step = position.from.piece_color == 'w' ? 3 : 4
    if !(position.to.x == board.enx && position.to.y == board.eny)
      false
    elsif position.from.y != step
      false
    # elsif position.delta_x != 1  # not sure.
    #   false
    elsif position.abs_delta_x == 1
      true
    end
  end

  def can_pawn_go(step_y)
    true if position.to.piece == ' ' && (position.delta_x == 0) && (position.delta_y == step_y)
  end

  def can_pawn_jump(step_y)
    if position.to.piece == ' ' && (position.delta_x == 0) && (position.delta_y == 2 * step_y) && ((position.from.y == 1 || position.from.y == 6)) && (board.board[position.from.y + step_y][position.from.x].piece == ' ')
      true
    end
  end

  def can_pawn_eat(step_y)
    if board.board[position.to.y][position.to.x].piece != ' ' && (position.abs_delta_x == 1) && (position.delta_y == step_y)
      true
    end
  end

  def can_move_straight?
    at = board.board[position.from.y][position.from.x]
    loop do
      at = board.board[at.y + position.sign_y][at.x + position.sign_x]
      if at == position.to
        return true
      elsif if at.instance_of?(NilClass)
              return false
            elsif at.y + position.sign_y >= 8
              return false
            end
      end
      break if at.piece != ' '
    end
  end

  # returns string in algebraic notation.
  def to_an_string
    return 'O-O-O' if king? && can_castle && position.abs_delta_x == 2 && position.to.x == 2
    return 'O-O' if king? && can_castle && position.abs_delta_x == 2 && position.to.x == 6

    piece = position.from.piece_char
    piece_str = pawn? ? '' : piece.upcase
    if position.to.x == board.enx && position.to.y == board.eny && (position.to.y - position.from.y).abs == 1 && pawn? # for an en_passant notation.
      "#{piece_str}#{position.from.define_position}x#{position.to.define_position}"
    else # for basic moves.
      "#{piece_str}#{position.from.define_position}#{position.to.piece == ' ' ? '' : 'x'}#{position.to.define_position}"
    end
  end
end
