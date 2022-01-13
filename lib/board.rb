class Board
  def initialize
    @board = create_board
  end

  def draw
    draw_board
  end

  def create_board
    board = []
    (0..7).each do |row|
      (0..7).each do |col|
        board << Square.new(row, col)
      end
    end
    board
  end

  def draw_board
    @board.each do |sq|
       sq.draw
     end
  end
end
