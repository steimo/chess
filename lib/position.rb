class Position
  attr_accessor :piece_from, :piece_to, :from, :to, :promotion

  PIECES = { R: '♖', N: '♘', B: '♗', Q: '♕', K: '♔', P: '♙', r: '♜', n: '♞', b: '♝', q: '♛', k: '♚', p: '♟' }

  def initialize(from, to)
    @from = from # Square class
    @to = to # Square class
    @promotion = promotion
    @piece_from = PIECES.key(from.piece).to_s || ''
    @piece_to = PIECES.key(to.piece).to_s || ''
  end

  def delta_x
    to.x - from.x
  end

  def delta_y
    to.y - from.y
  end

  def abs_delta_x
    delta_x.abs
  end

  def abs_delta_y
    delta_y.abs
  end

  def sign_x
    # "++-"[delta_x <=> 0]
    [0, 1, -1][delta_x <=> 0]
  end

  def sign_y
    # "++-"[delta_y <=> 0]
    [0, 1, -1][delta_y <=> 0]
  end
end
