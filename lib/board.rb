class Board
  # attr_accessor :board, :turn, :castling, :ep, :halfmove, :fullmove, :king
  attr_accessor :board, :fen

  def initialize(fen = PGN::FEN.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'))
    @fen = fen
    @board = initialize_board
    @turn = :white
    # @castling = 'KQkq'
    # @ep = nil
    # @halfmove = 0
    # @fullmove = 1
    # @king = { white: e1, black: e8 }
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

  # def set_piece_at(from, to)
  #   @board[from.y][from.x] = Square.new(from.x, from.y, '')
  #   @board[to.y][to.x] = Square.new(to.x, to.y, from.piece)
  # end

  def create_fen(position)
    piece = position.piece.to_s == 'P' || position.piece.to_s == 'p' ? '' : position.piece.to_s
    move = "#{piece.capitalize}#{position.from.define_position}#{position.to.piece == " " ? '' : 'x'}#{position.to.define_position}"
    puts move
    position = @fen.to_position.move(move)
    position.to_fen
  end

  def move(position)
    Board.new(create_fen(position))
  end
end
