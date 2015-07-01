require_relative 'display'
require_relative 'board'
require_relative 'pieces'
require 'colorize'
require 'io/console'
require 'byebug'

class Game

  attr_reader :display, :board
  attr_accessor :selected_pos, :previously_selected_pos

  def initialize
    @board = Board.new
    @display = Display.new(@board, self)
    @debug = true
    @selected_pos = nil
    @previously_selected_pos = nil
  end


  def run
    until over?
      display.render
      display.render_debug if debug
      input = $stdin.getch
      break if input == 'q'
      position_selected if input == "\r"
      display.receive_input(input)
    end
  end

  def position_selected
    self.selected_pos = display.cursor
    if previously_selected_pos
      try_to_move_piece
    else
      update_previously_selected_position
    end
  end

  def try_to_move_piece
    piece = board[previously_selected_pos]
    if previously_selected_pos == selected_pos
      self.previously_selected_pos = nil
    end

    if piece.valid_move?(selected_pos)
      board.move(previously_selected_pos, selected_pos)
      self.previously_selected_pos = nil
    end
  end

  def update_previously_selected_position
    square = board[selected_pos]
    self.previously_selected_pos = selected_pos unless square.empty?
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
