class Square
  attr_reader :row, :column, :position, :width
attr_accessor :width
  def initialize(row, column)
    @row = row
    @column = column
    @position = define_position
    @width = 100
    @headline_font = Gosu::Font.new(20, name: 'fonts/unifont-14.0.01.ttf')
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

  def draw
    light = Gosu::Color.rgba(238, 238, 210, 255)
    dark = Gosu::Color.rgba(118, 150, 86, 255)
    color = (@row + @column).even? ? dark : light
     x =  @column * @width  
     y = 700 -  @row * @width 
    $window.draw_quad(x, y, color,
                      x + @width, y, color,
                      x + @width, y + @width, color,
                      x, y + @width, color)
    @headline_font.draw_text("#{@position}", x, y, 10, 1, 1, Gosu::Color::BLACK)
  end
end
