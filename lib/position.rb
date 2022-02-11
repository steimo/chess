class Position
  attr_accessor :piece, :from, :to, :promotion

  def initialize(from, to)
    @piece = from.piece
    @from = from  
    @to = to
    @promotion = promotion
  end
end
