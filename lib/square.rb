class Square
  attr_reader :position

  def initialize(row, column)
    @row = row
    @column = column
    @position = define_position
  end

  def define_position
    position = ''
    ('a'..'h').each.with_index do |col, i|
      (1..8).each.with_index do |row, j|
        position = "#{col}#{row}" if @column == i && @row == j
      end
    end
    position
  end
end
