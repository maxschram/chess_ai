class HumanPlayer

  attr_reader :display, :color
  attr_accessor :previously_selected_pos, :selected_pos

  def initialize(color, display)
    @display = display
    @previously_selected_pos = nil
    @selected_pos = nil
    @color = color
  end

  def take_turn
    self.previously_selected_pos = nil
    self.selected_pos = nil

    until previously_selected_pos && selected_pos
      display.render
      # display.render_debug(console: debug_console) if debug
      # display.render_debug
      # debug_console = false
      input = $stdin.getch
      exit if input == 'q'
      # debug_console = true if input == 'c'
      position_selected if input == "\r"
      display.receive_input(input)
    end
    [previously_selected_pos, selected_pos]
  end

  private

  def position_selected
    if selected_pos
      self.previously_selected_pos = selected_pos
      self.selected_pos = display.cursor
    else
      self.selected_pos = display.cursor
    end
  end
end
