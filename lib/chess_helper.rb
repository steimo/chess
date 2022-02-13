module ChessHelper
  ('a'..'h').each.with_index do |col, i|
    (1..8).each.with_index do |row, j|
      define_method("#{col}#{row}") { i + j * 8 }
    end
  end

  # class Array
  #   def to_idx
  #     self[0] + 1 + (self[1] + 2)*10
  #   end
  # end
  # class String
  #   def to_idx
  #     self[0].ord - 'a'.ord + 1 + ('8'.ord - self[1].ord + 2)*10
  #   end
  # end
  class Integer
    def to_sq
      (('a'.ord + self % 8).chr + ('8'.ord - self / 8).chr).to_sym
    end
  end
end

