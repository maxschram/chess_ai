require_relative 'display'
require_relative 'board'
require_relative 'pieces'
require 'colorize'
require 'io/console'

class Game

  attr_reader :display

  def initialize
    @board = Board.new
    @display = Display.new(@board)
  end

  def run
    until over?
      display.render
      input = $stdin.getch
      break if input == 'q'
      display.receive_input(input)
    end
  end

  def over?
    false
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
