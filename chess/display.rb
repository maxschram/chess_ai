class Display

  attr_accessor :cursor, :game

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
    system('clear')
    (0...@board.length).each do |row|
      (0...@board.length).each do |col|
        print square_string([row, col])
      end
      print "\n"
    end
    puts "Use WASD for movement, Enter to select or place a piece, Q for quit"
  end

  def render_debug
    debug_msg = ""
    debug_msg += "Cursor position: #{cursor}\n"
    debug_msg += "Highlighted space position: #{board[cursor].pos}\n"
    debug_msg += "Highlighted space empty?: #{board[cursor].empty?}\n"
    debug_msg += "Selected position: #{game.selected_pos}\n"
    if game.selected_pos
      debug_msg += "Selected position moves: #{board[game.selected_pos].moves}\n"
    end
    puts debug_msg
  end
  private

  attr_reader :board

  def square_odd?(pos)
    pos.reduce(:+).odd?
  end

  def square_string(pos)
    if pos == cursor
      background_color = :yellow
    elsif square_odd?(pos)
      background_color = :red
    else
      background_color = :green
    end

    " #{board[pos]} ".colorize(background: background_color)
  end

  def update_cursor_pos(pos)
    new_cursor_pos = cursor.zip(pos).map { |dim| dim.reduce(:+) }
    return unless board.on_board?(new_cursor_pos)
    @cursor = new_cursor_pos
  end

end
