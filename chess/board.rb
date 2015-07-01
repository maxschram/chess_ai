class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate_squares
    populate(:white)
    populate(:black)
  end

  def in_check?(color)
    raise "not yet implemented"
  end

  def move(start, end_pos)
    self[end_pos] = self[start]
    self[start] = EmptySquare.new
  end

  def length
    grid.length
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    grid[row][col] = val
  end

  def on_board?(pos)
    pos.all? {|dim| dim.between?(0, length - 1)}
  end

  def valid_move?(piece, pos)
    on_board?(pos) && (self[pos].empty? || piece.color != self[pos].color)
  end

  def valid_take?(piece, pos)
    on_board?(pos) && !self[pos].empty? && piece.color != self[pos].color
  end

  def move_pos(pos, diff)
    pos.zip(diff).map { |dim| dim.reduce(:+) }
  end

  private

  attr_accessor :grid

  def populate(color)
    row = (color == :white ? 7 : 0)
    pawn_row = (color == :white ? 6 : 1)
    grid[row][0] = Rook.new([row,0], self, color)
    grid[row][7] = Rook.new([row,7], self, color)
    grid[row][1] = Knight.new([row,1], self, color)
    grid[row][6] = Knight.new([row,6], self, color)
    grid[row][2] = Bishop.new([row,2], self, color)
    grid[row][5] = Bishop.new([row,5], self, color)
    grid[row][3] = Queen.new([row,3], self, color)
    grid[row][4] = King.new([row,4], self, color)

    (0..7).each { |col| grid[pawn_row][col] = Pawn.new([pawn_row, col], self, color) }
    # grid[2][3] = Pawn.new([2,3], self, color)

  end

  def populate_squares
    (0...length).each do |row_idx|
      (0...length).each do |col_idx|
        grid[row_idx][col_idx] = EmptySquare.new([row_idx, col_idx])
      end
    end
  end

end

class EmptySquare

  attr_reader :pos

  def initialize(pos)
    @pos = pos
  end

  def moves
    []
  end

  def empty?
    true
  end

  def to_s
    " "
  end

end
