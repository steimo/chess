class Button
  attr_accessor :text

  def initialize(text, shift)
    @text = text
    @shift = shift
    @option = 0
    @font = Gosu::Font.new(45, { name: 'fonts/unifont-14.0.01.ttf', bold: true })
    @color = Gosu::Color.rgba(0, 0, 0, 255)
  end

  def draw_button
    @font.draw_text(@text, x_position, y_position + @option, 10, 1.0, 1.0, @color)
  end

  def update
    if mouse_over_button
      @color = Gosu::Color.rgba(1, 210, 161, 254)
      @option = 1.5
    else
      @color = Gosu::Color.rgba(0, 0, 0, 255)
      @option = 0
    end
  end

  def x_position
    $window.width / 2 - @font.text_width(@text.to_s) / 2
  end

  def y_position
    $window.height / 2 - @font.text_width(@text.to_s) / 2 - @shift
  end

  def mouse_over_button
    $window.mouse_x.between?(x_position,
                             x_position + @font.text_width(@text)) && $window.mouse_y.between?(y_position,
                                                                                               y_position + @font.height)
  end
end
