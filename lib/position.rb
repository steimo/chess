class Position
  attr_accessor :piece_from, :piece_to, :from, :to, :promotion

  PIECES = { R: '♖', N: '♘', B: '♗', Q: '♕', K: '♔', P: '♙', r: '♜', n: '♞', b: '♝', q: '♛', k: '♚', p: '♟' }
  def initialize(from, to)
    @from = from  
    @to = to
    @promotion = promotion
    @piece_from = PIECES.key(from.piece) || ''
    @piece_to = PIECES.key(to.piece) || ''
  end
end
