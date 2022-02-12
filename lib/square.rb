class Square
  # attr_accessor :color, :piece, :selected
  PIECES = { R: '♖', N: '♘', B: '♗', Q: '♕', K: '♔', P: '♙', r: '♜', n: '♞', b: '♝', q: '♛', k: '♚', p: '♟' }
  # attr_reader :width, :font
  attr_accessor :x, :y, :piece, :width, :font, :font_x, :color

  def initialize(x, y, piece)
    @x = x_input(x)
    @y = y_input(y)
    @piece = piece
    # @piece = Piece.new(piece.to_sym)
    @width = 100
    @font = Gosu::Font.new(80, name: 'fonts/chess_merida_unicode.ttf')
    @font_x = Gosu::Font.new(10, name: 'fonts/unifont-14.0.01.ttf')
  end

  def on_board?
    true if x >= 0 && x < 8 && y >= 0 && y < 8
  end

  def update
    if mouse_over_square
      @color = Gosu::Color.rgba(1, 210, 161, 254)
    else
      @color = Gosu::Color::BLACK
    end
  end

  def x_input(x)
    return x if x.is_a?(Integer)

    x = x.ord - 'a'.ord
  end

  def y_input(y)
    return y if y.is_a?(Integer)

    y = y.ord - '1'.ord
  end

  def draw
    x = @x
    y = @y
    light = Gosu::Color.rgba(238, 238, 210, 255)
    dark = Gosu::Color.rgba(118, 150, 86, 255)
    color = (x + y).even? ? light : dark
    x *= width
    y *= width
    $window.draw_quad(x, y, color,
                      x + width, y, color,
                      x + width, y + width, color,
                      x, y + width, color)
    str = PIECES[piece] || ''
    cx = (width - font.text_width(str)) / 2
    px = (width - font.text_width(piece)) / 2
    font.draw_text(piece, x + px, y + 15, 1, 1, 1, @color)
    font_x.draw_text("#{@x}#{@y}", x + cx, y, 1, 1, 1, Gosu::Color::BLACK)
  end

  def mouse_over_square
    x = @x * width
    y = @y * width
    $window.mouse_x.between?(x, x + width - 2) && $window.mouse_y.between?(y, y + width - 2)
  end
end
