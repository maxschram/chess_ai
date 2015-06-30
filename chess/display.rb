class Display

  MOVEMENTS = {"w" => [-1, 0]
               "a" => [0, -1]
               "s" => [0, 1]
               "d" => [1, 0]
               "\r"=> [0, 0]}

  def initialize(board)
    @cursor = [0,0]
    @board = board
  end

  def receive_input(char)
    return unless MOVEMENTS.has_key?(char)
    update_cursor_pos(MOVEMENTS[char])
    render
  end

  def render
    (0..@board.length) do |row|
      (0..@board.length).each do |col|
        print square_string([row, col])
      end
      print "\n"
    end
  end

  private

  attr_reader :board

  def square_odd?(pos)
    pos.reduce(:+).odd?
  end

  def square_string(pos)
    background_color = square_odd?(pos) ? :red : :green
    " #{board[pos]} ".colorize(background: background_color)
  end

end
