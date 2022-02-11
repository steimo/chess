class Piece
  PIECES = { R: '♖', N: '♘', B: '♗', Q: '♕', K: '♔', P: '♙', r: '♜', n: '♞', b: '♝', q: '♛', k: '♚', p: '♟' }

  attr_accessor :piece

  def initialize(string)
    @piece = PIECES[string] || ''
  end
end
