class Display

  attr_accessor :cursor

  MOVEMENTS = {"w" => [-1, 0],
               "a" => [0, -1],
               "s" => [1, 0],
               "d" => [0, 1],
               "\r"=> [0, 0]}

  def initialize(board)
    @cursor = [0,0]
    @board = board
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

  private

  attr_reader :board

  def square_odd?(pos)
    pos.reduce(:+).odd?
  end

  def square_string(pos)
    if pos == cursor
      background_color = :yellow
    elsif square_odd?(pos)
      background_color = :black
    else
      background_color = :white
    end

    " #{board[pos]} ".colorize(background: background_color)
  end

  def update_cursor_pos(pos)
    new_cursor_pos = cursor.zip(pos).map { |dim| dim.reduce(:+) }
    return unless board.on_board?(new_cursor_pos)
    @cursor = new_cursor_pos
  end

end
