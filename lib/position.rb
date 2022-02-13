class Position
  attr_accessor :piece, :from, :to, :promotion

  PIECES = { R: '♖', N: '♘', B: '♗', Q: '♕', K: '♔', P: '♙', r: '♜', n: '♞', b: '♝', q: '♛', k: '♚', p: '♟' }
  def initialize(from, to)
    @from = from  
    @to = to
    @promotion = promotion
    @piece = PIECES.key(from.piece) || ''
  end
end
