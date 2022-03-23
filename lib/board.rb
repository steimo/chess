class Board
  attr_accessor :board, :fen, :king_under_check

  $can_white_castle_right = true
  $can_white_castle_left = true
  $can_black_castle_right = true
  $can_black_castle_left = true
  def initialize(fen = PGN::FEN.new('r3k2r/6Pr/8/8/8/8/Rp6/R3KN1R w KQkq - 0 1'))
    @fen = fen
    @board = initialize_board
    # @turn = :white
    # @flip = false
    # puts fen
  end

  def initialize_board
    # board = %w[
    #   r n b q k b n r
    #   p p p p p p p p
    #   - - - - - - - -
    #   - - - - - - - -
    #   - - - - - - - -
    #   - - - - - - - -
    #   P P P P P P P P
    #   R N B Q K B N R
    # ].each_slice(8).to_a.map.with_index do |row, y|
    #   row.map.with_index do |column, x| # column represents piece
    #     Square.new(x, y, column)
    #   end
    # end
    # fen = PGN::FEN.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    position = fen.to_position
    arr = []
    arr << position.inspect
    arr = arr[0].split("\n")
    arr.shift
    arr = arr.map do |sector|
            sector.chars
          end.flatten.map { |s| s == ' ' ? '' : s }.reject { |c| c.empty? }.map { |w| w == '_' ? ' ' : w }
    arr.each_slice(8).to_a.map.with_index do |row, y|
      row.map.with_index do |column, x| # column represents piece
        Square.new(x, y, column)
      end
    end
  end

  def define_position_at(sq) # 'e2' => 52
    return sq if sq.is_a?(Integer)

    sq[0].ord - 'a'.ord + ('8'.ord - sq[1].ord) * 8
  end

  def draw
    @board.each_slice(8).to_a.each do |arr|
      arr.each.with_index do |row, _y|
        row.each.with_index do |column, _x|
          column.draw
        end
      end
    end
  end

  def update
    @board.each_slice(8).to_a.each do |arr|
      arr.each.with_index do |row, _y|
        row.each.with_index do |column, _x|
          column.update
        end
      end
    end
  end

  # def yield_pieces
  #   result = []
  #   board.flatten.each do |square|
  #     result << PieceOnSquare.new(square.piece_str, square) if square.piece_color == fen.active
  #   end
  #   result
  # end

  def yield_squares
    result = []
    board.flatten.each do |square|
      if square.piece == ' '
        result << square
      elsif square.piece_color != fen.active
        result << square
      end
    end
    result
  end

  def move(position)
    @position = position
    move = Move.new(self, position)
    string = move.to_algebraic_notation_string
    position = @fen.to_position.move(string.strip)
    new = position.to_fen
    Board.new(new)
  end

  def find_opposite_king
    str = fen.active == 'b' ? 'K' : 'k'
    board.flatten.detect { |sq| sq.piece_str.to_s == str }
  end
  
  def find_king
    str = fen.active == 'b' ? 'k' : 'K'
    board.flatten.detect { |sq| sq.piece_str.to_s == str }
  end

  def square_is_empty?(x, y)
    square = board[y][x]
    square.piece == ' '
  end

  def yield_pieces_for_def # returns opposite pieces
    str = fen.active == 'b' ? /\b[a-z]+\b/ : /\b[A-Z]+\b/
    result = []
    board.flatten.each do |square|
      result << square if square.piece_str.match(str)
    end
    result
  end

  # asdl;fjasdl;jf;lasdfjs;la
  def can_eat_king
    str = fen.active == 'b' ? /\b[a-z]+\b/ : /\b[A-Z]+\b/
    bad_king = find_opposite_king
    board.flatten.each do |p|
      next unless p.piece_str.match(str)

      position = Position.new(p, bad_king)
      move = Move.new(self, position)
      return true if move.can_move
    end
    false
  end

  def is_check_after_move(pos)
    # x = fen.active == 'w' ? :b : :w
    after = Board.new(fen)
    after = after.move(pos)
    after.can_eat_king
  end

  # refactoring < < < < < < < < < < <

  def yield_pieces_for_fff # returns opposite pieces
    str = fen.active == 'b' ? /\b[A-Z]+\b/ : /\b[a-z]+\b/
    result = []
    board.flatten.each do |square|
      result << PieceOnSquare.new(square.piece_str, square) if square.piece_str.match(str)
    end
    result
  end

  def is_king_under_check
    str = fen.active == 'b' ? 'k' : 'K'
    king = board.flatten.detect { |sq| sq.piece_str.to_s == str }
    x = yield_pieces_for_fff.each do |p|
      position = Position.new(p.square, king)
      move = Move.new(self, position)
      str = fen.active == 'b' ? 'k' : 'K'
      king = board.flatten.detect { |sq| sq.piece_str.to_s == str }
      king.checked = true if move.can_piece_move
      return @king_under_check = true if move.can_piece_move
    end
    @king_under_check = false
  end
  # def find_last_move(position)
  #     @last_move_x = position.to.x if  %w[P p].include?(position.from.piece_str.to_s) && (position.to.y - position.from.y).abs
  #     @last_move_y = position.to.y if  %w[P p].include?(position.from.piece_str.to_s) && (position.to.y - position.from.y).abs
  # end
end
