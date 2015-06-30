require_relative 'display'
require_relative 'board'
require_relative 'pieces'
require 'colorize'
require 'io/console'

class Game

  attr_reader :display
  attr_accessor :selected_pos

  def initialize
    @board = Board.new
    @display = Display.new(@board, self)
    @debug = true
    @selected_pos = nil
  end


  def run
    until over?
      display.render
      display.render_debug if debug
      input = $stdin.getch
      break if input == 'q'
      self.selected_pos = display.cursor if input == "\r"
      display.receive_input(input)
    end
  end

  def over?
    false
  end

  private

  attr_reader :debug
end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
