class GameState
  def self.switch(new_state)
    $window.state = new_state
  end

  def enter; end

  def leave; end

  def draw; end

  def update; end

  def needs_redraw?
    true
  end

  def button_down(id); end

  def button_up(id); end
end
