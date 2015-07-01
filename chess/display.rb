class Display

  attr_accessor :cursor, :game
  attr_reader :board

  MOVEMENTS = {"w" => [-1, 0],
               "a" => [0, -1],
               "s" => [1, 0],
               "d" => [0, 1],
               "\r"=> [0, 0]}

  def initialize(board, game)
    @cursor = [0,0]
    @board = board
    @game = game
  end

  def receive_input(char)
    render
    return unless MOVEMENTS.has_key?(char)
    update_cursor_pos(MOVEMENTS[char])
  end

  def render
    board = ''
    instructions = ''
    current_player = game.players[game.current_player]
    system('clear')
    (0...@board.length).each do |row|
      (0...@board.length).each do |col|
        board << square_string([row, col])
      end
      board << "\n"
    end
    instructions << "\nUse WASD for movement, Enter to select or place a piece, Q for quit\n"
    instructions << "Current player: #{current_player.color.to_s.upcase.colorize(current_player.color)}".on_green
    instructions << " " * 46
    puts board
    puts instructions.colorize(background: :magenta)
  end

  def debug_console
    print "\nEnter a command: \n>"
    command = gets.chomp
    puts eval(command)
  end

  def render_debug(options = {})
    selected_pos = game.players[game.current_player].selected_pos
    debug_msg = ""
    debug_msg += "Cursor position: #{cursor}\n"
    debug_msg += "Highlighted space position: #{board[cursor].pos}\n"
    debug_msg += "Highlighted space empty?: #{board[cursor].empty?}\n"
    debug_msg += "Selected position: #{selected_pos}\n"
    if game.selected_pos
      debug_msg += "Selected position moves: #{board[selected_pos].moves}\n"
    end
    debug_msg += "Piece at highlighted position: #{board[cursor].class}\n" if board[cursor]
    debug_msg += "Highlighted piece color #{board[cursor].color}\n" unless board[cursor].empty?
    debug_msg += "Piece at selected position: #{board[selected_pos].class}\n" if game.selected_pos && board[game.selected_pos]
    debug_msg += "Black king at #{board.find_king(:black).pos}\n"
    debug_msg += "White king at #{board.find_king(:white).pos}\n"
    debug_msg += "White in check #{board.in_check?(:white)}\n"
    debug_msg += "Black in check #{board.in_check?(:black)}\n"
    debug_msg += "Black checkmate #{board.checkmate?(:black)}\n"
    debug_msg += "White checkmate #{board.checkmate?(:white)}\n"
    puts debug_msg
    debug_console if options[:console]
  end

  def empty_square?(pos)
    board[pos].empty?
  end

  private

  def square_odd?(pos)
    pos.reduce(:+).odd?
  end

  def square_string(pos)
    piece = board[pos].to_s
    piece = piece.colorize(:yellow) if game.players[game.current_player].selected_pos == pos
    if pos == cursor
      background_color = :yellow
    elsif square_odd?(pos)
      background_color = :red
    else
      background_color = :blue
    end

    " #{piece} ".colorize(background: background_color)
  end

  def update_cursor_pos(pos)
    new_cursor_pos = cursor.zip(pos).map { |dim| dim.reduce(:+) }
    return unless board.on_board?(new_cursor_pos)
    @cursor = new_cursor_pos
  end
end
