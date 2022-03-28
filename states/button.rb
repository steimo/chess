class Button
  attr_accessor :text, :load_state_x, :load_state_y

  def initialize(text, shift, load_state_x=0, load_state_y=0)
    @text = text
    @shift = shift
    @load_state_x = load_state_x
    @load_state_y = load_state_y
    @font = Gosu::Font.new(45, name: 'fonts/unifont-14.0.01.ttf')
  end

  def draw_button
    @font.draw_text(@text, define_x, define_y + @option, 10, 1.0, 1.0, @color)
  end

  def update
    if mouse_over_button
      @color = Gosu::Color.rgba(1, 210, 161, 254)
      @option = 2.5
    else
      @color = Gosu::Color.rgba(0, 0, 0, 255)
      @option = 0
    end
  end

  def define_x
    $window.width / 2 - @font.text_width(@text.to_s) / 2 + @load_state_x
  end

  def define_y
    $window.height / 2 - @shift - 100 + @load_state_y
  end

  def mouse_over_button
    $window.mouse_x.between?(define_x, define_x + @font.text_width(@text)) && $window.mouse_y.between?(define_y, define_y + @font.height)
  end
end
