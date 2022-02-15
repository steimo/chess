module ChessHelper
  ('a'..'h').each.with_index do |col, i|
    (1..8).each.with_index do |row, j|
      define_method("#{col}#{row}") { i + j * 8 }
    end
  end
end

class String
  def pawn?
    self == :P || self == :p
  end

  def king?
    self == :K || self == :k
  end
end

class Integer
  def to_sq
    (('a'.ord + self % 8).chr + ('8'.ord - self / 8).chr).to_sym
  end
end
