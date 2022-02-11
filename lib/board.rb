class Board
  # attr_accessor :board, :turn, :castling, :ep, :halfmove, :fullmove, :king
  attr_accessor :board

  def initialize
    # @fen = fen
    @board = initialize_board
    @turn = :white
    # @castling = 'KQkq'
    # @ep = nil
    # @halfmove = 0
    # @fullmove = 1
    # @king = { white: e1, black: e8 }
  end

  def initialize_board
    board = %w[
      r n b q k b n r
      p p p p p p p p
      - - - - - - - -
      - - - - - - - -
      - - - - - - - -
      - - - - - - - -
      P P P P P P P P
      R N B Q K B N R
    ].each_slice(8).to_a.map.with_index do |row, y|
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

  # def move(from, to)
  #   piece = @board[from].piece
  #   @board[to] = Square.new(piece)
  #   @board[from] = Square.new('')
  # end

  # def move_valid?(from, to)
  #   true if !from.nil? && !to.nil? && from != to
  # end

  def set_piece_at(from, to)
    @board[from.y][from.x] = Square.new(from.x, from.y, "")
    @board[to.y][to.x] = Square.new(to.x, to.y, from.piece)
  end

  def move(position)
    board_next = Board.new
    board_next.set_piece_at(position.from, position.to)
    board_next
  end
end
