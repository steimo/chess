class Board
  attr_reader :enx, :eny
  attr_accessor :board, :fen

  def initialize(fen)
    @fen = fen
    @board = initialize_board
    define_en
  end

  def initialize_board
    position = fen.to_position
    arr = []
    arr << position.inspect
    arr = arr[0].split("\n")
    arr.shift
    arr = arr.map(&:chars).flatten.map { |s| s == ' ' ? '' : s }.reject(&:empty?).map { |w| w == '_' ? ' ' : w }
    arr.each_slice(8).to_a.map.with_index do |row, y|
      row.map.with_index do |column, x| # column represents a piece.
        Square.new(x, y, column)
      end
    end
  end

  def draw
    board.flatten.each(&:draw)
  end

  def update
    board.flatten.each(&:update)
  end

  def define_en
    en_position = fen.en_passant
    pgn_board = fen.to_position.board
    en_coord = pgn_board.coordinates_for(en_position)
    if en_position == '-'
      @enx = -1
      @eny = -1
    else
      @enx = en_coord[0]
      @eny = 7 - en_coord[1]
    end
  end

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
    move = Move.new(self, position)
    string = move.to_an_string                     # creates move in algebraic notation.
    position = @fen.to_position.move(string.strip) # makes move using PGN parser.
    new = position.to_fen                          # returns new fen after making move with PGN parser.
    Board.new(new)                                 # returns new board back to play state.
  end

  def find_opposite_king
    str = fen.active == 'b' ? 'K' : 'k'
    board.flatten.detect { |sq| sq.piece_char == str }
  end

  def find_king
    str = fen.active == 'b' ? 'k' : 'K'
    board.flatten.detect { |sq| sq.piece_char == str }
  end

  def square_is_empty?(x, y)
    square = board[y][x]
    square.piece == ' '
  end

  def can_eat_king
    str = fen.active == 'b' ? /\b[a-z]+\b/ : /\b[A-Z]+\b/
    bad_king = find_opposite_king
    board.flatten.each do |p|
      next unless p.piece_char.match(str)

      position = Position.new(p, bad_king)
      move = Move.new(self, position)
      return true if move.can_move
    end
    false
  end

  def is_check_after_move(position)
    # after = Board.new(fen)        # <=
    # after = after.move(position) # <=
    # after.can_eat_king          # <=
    after = move(position) # <= not sure, needs testing.
    after.can_eat_king
  end

  def king_under_check?
    occurrence = fen.active == 'b' ? /\b[A-Z]+\b/ : /\b[a-z]+\b/
    str = fen.active == 'b' ? 'k' : 'K'
    king = board.flatten.detect { |sq| sq.piece_char == str }
    board.flatten.each do |p|
      next unless p.piece_char.match(occurrence)

      position = Position.new(p, king)
      move = Move.new(self, position)
      if move.can_piece_move
        king.checked = true
        return true
      end
    end
    false
  end
end
