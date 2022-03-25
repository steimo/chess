class Square
  PIECES = { R: '♖', N: '♘', B: '♗', Q: '♕', K: '♔', P: '♙', r: '♜', n: '♞', b: '♝', q: '♛', k: '♚', p: '♟' }
  attr_accessor :x, :y, :piece, :selected, :highlighted, :checked, :moved

  def initialize(x, y, piece)
    @x = x
    @y = y
    @piece = piece
    @width = 100
    @moved = false
    @checked = false
    @selected = false
    @highlighted = false
    @font = Gosu::Font.new(80, name: 'fonts/chess_merida_unicode.ttf')
  end

  def piece_color
    piece = PIECES.key(@piece) || ''
    /[[:upper:]]/.match(piece) ? 'w' : 'b'
  end

  def piece_char
    piece = PIECES.key(@piece) || ''
    piece.to_s
  end

  def update
    @color = if mouse_over_square
               Gosu::Color.rgba(20, 225, 160, 100)
             else
               Gosu::Color::BLACK
             end
    # puts define_position if mouse_over_square
    # puts "x:#{@x} y:#{@y}" if mouse_over_square
  end

  # returns position on board, like: (e2, h8, etc.).
  def define_position
    ranks = ('a'..'h').to_a
    files = (1..8).to_a
    ranks.each.with_index do |col, i|
      files.each.with_index do |row, j|
        x = @x
        y = 7 - @y
        return "#{col}#{row}" if i == x && j == y
      end
    end
  end

  def draw
    x = @x
    y = @y
    light = Gosu::Color.rgba(238, 238, 210, 255)
    dark = Gosu::Color.rgba(118, 150, 86, 255)
    color = (x + y).even? ? light : dark
    x *= @width
    y *= @width
    if $flip
      x = (7 - @x) * @width
      y = (7 - @y) * @width
    end
    draw_quad(x, y, color)
    if $flip
      gx = (7 - @x) * @width
      gy = (7 - @y) * @width
    else
      gx = x
      gy = y
    end
    px = (@width - @font.text_width(piece)) / 2
    @font.draw_text(piece, gx + px, gy + 15, 1, 1, 1, @color) # draws piece on the square.
    moved_color = Gosu::Color.rgba(246, 246, 150, 255)
    checked_king_color = Gosu::Color.rgba(231, 53, 54, 255)
    selected_color = Gosu::Color.rgba(27, 171, 163, 125)
    draw_quad(x, y, moved_color) if moved
    draw_quad(x, y, checked_king_color) if checked
    draw_quad(x, y, selected_color) if selected
    draw_quad(x, y, selected_color) if highlighted
  end

  def draw_quad(x, y, color)
    $window.draw_quad(x, y, color,
                      x + @width, y, color,
                      x + @width, y + @width, color,
                      x, y + @width, color)
  end

  def mouse_over_square
    if $flip
      x = (7 - @x) * @width
      y = (7 - @y) * @width
    else
      x = @x * @width
      y = @y * @width
    end
    $window.mouse_x.between?(x, x + @width - 2) && $window.mouse_y.between?(y, y + @width - 2)
  end
end
