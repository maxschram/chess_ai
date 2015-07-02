require_relative 'display'
require_relative 'board'
require_relative 'pieces'
require_relative 'human_player'
require 'colorize'
require 'io/console'
require 'byebug'

class Game
  attr_reader :display, :board, :players
  attr_accessor :selected_pos, :previously_selected_pos, :current_player

  def initialize
    @board = Board.new
    @display = Display.new(@board, self)
    @debug = true
    @players = [HumanPlayer.new(:white, display), HumanPlayer.new(:black, display)]
    @current_player = 0
    @player_in_check = false
    @over = false
  end

  def run
    debug_console = false
    until over?
      update_check_state
      begin
        start_pos, end_pos = players[current_player].take_turn
        try_to_move_piece(start_pos, end_pos)
      rescue InvalidMove
        retry
      end
      switch_players
    end
  end

  def over?
    over
  end

  def check?
    player_in_check
  end

  private

  attr_reader :debug
  attr_accessor :over, :player_in_check

  def update_check_state
    self.player_in_check = board.in_check?(players[current_player].color)
    self.over = board.checkmate?(players[current_player].color)
  end

  def try_to_move_piece(start_pos, end_pos)
    piece = board[start_pos]
    if valid_move_for_current_player?(start_pos, end_pos)
      board.move(start_pos, end_pos)
      piece.moved!
    else
      raise InvalidMove
    end
  end

  def valid_move_for_current_player?(start_pos, end_pos)
    piece = board[start_pos]
    !piece.empty? && board.valid_move?(piece, end_pos) &&
      piece.valid_move?(end_pos) && piece.color == players[current_player].color
  end

  def switch_players
    self.current_player = 1 - current_player
  end

end

class InvalidMove < StandardError
end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
