class Pawn < Piece
  def initialize(color)
    super color
    @has_moved = false
  end
end
