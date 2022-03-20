class Square
  # attr_accessor :color, :piece, :selected
  PIECES = { R: '♖', N: '♘', B: '♗', Q: '♕', K: '♔', P: '♙', r: '♜', n: '♞', b: '♝', q: '♛', k: '♚', p: '♟' }
  # attr_reader :width, :font
  attr_accessor :x, :y, :piece, :width, :font, :font_x, :color, :selected, :to_selected

  def initialize(x, y, piece)
    @x = x_input(x)
    @y = y_input(y)
    @piece = piece
    # @piece = Piece.new(piece.to_sym)
    @width = 100
    @font = Gosu::Font.new(80, name: 'fonts/chess_merida_unicode.ttf')
    @font_x = Gosu::Font.new(10, name: 'fonts/unifont-14.0.01.ttf')
    @selected = false
    @to_selected = false
  end

  def on_board?
    true if x >= 0 && x < 8 && y >= 0 && y < 8
  end

  def piece_color
    piece = PIECES.key(@piece) || ''
    /[[:upper:]]/.match(piece) ? 'w' : 'b'
  end

  def piece_str
    piece = PIECES.key(@piece) || ''
  end

  def update
    @color = if mouse_over_square
               Gosu::Color.rgba(1, 210, 161, 254)
             else
               Gosu::Color::BLACK
             end
    # puts define_position if mouse_over_square
    #puts "x:#{@x} y:#{@y}" if mouse_over_square
  end

  def x_input(x)
    return x if x.is_a?(Integer)

    x = x.ord - 'a'.ord
  end

  def y_input(y)
    return y if y.is_a?(Integer)

    y = y.ord - '1'.ord
  end

  def define_position # returns position on board
    ranks = ('a'..'h').to_a
    files = (1..8).to_a
    ranks.each.with_index do |col, i|
      files.each.with_index do |row, j|
        y = 7 - @y
        x = @x
        return "#{col}#{row}" if i == x && j == y
      end
    end
  end

  def highlight_from
    x = @x
    y = @y
    color = Gosu::Color.rgba(48, 255, 150, 82)
    x *= width
    y *= width
    if $flip
      x = (7 - @x) * width
      y = (7 - @y) * width
    end
    $window.draw_quad(x, y, color,
                      x + width, y, color,
                      x + width, y + width, color,
                      x, y + width, color)
  end

  def draw
    x = @x
    y = @y
    light = Gosu::Color.rgba(238, 238, 210, 255)
    dark = Gosu::Color.rgba(118, 150, 86, 255)
    color = (x + y).even? ? light : dark
    x *= width
    y *= width
    if $flip
      x = (7 - @x) * width
      y = (7 - @y) * width
    end
    $window.draw_quad(x, y, color,
                      x + width, y, color,
                      x + width, y + width, color,
                      x, y + width, color)
    if $flip
      gx = (7 - @x) * width
      gy = (7 - @y) * width
    else
      gx = x
      gy = y
    end
    str = PIECES[piece] || ''
    cx = (width - font.text_width(str)) / 2
    px = (width - font.text_width(piece)) / 2
    font.draw_text(piece, gx + px, gy + 15, 1, 1, 1, @color)
    # font_x.draw_text("#{@x}#{@y}", x + cx, y, 1, 1, 1, Gosu::Color::BLACK)
    # highlight_from if  mouse_over_square && selected
    highlight_from if to_selected
    highlight_from if selected
  end

  def mouse_over_square
    if $flip
      x = (7 - @x) * width
      y = (7 - @y) * width
    else
      x = @x * width
      y = @y * width
    end
    $window.mouse_x.between?(x, x + width - 2) && $window.mouse_y.between?(y, y + width - 2)
  end

  def ==(other)
    x == other.x && y == other.y && piece == other.piece
  end
end
