class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) {EmptySquare.new} }
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

  private

  attr_accessor :grid
end

class EmptySquare

  def moves
    []
  end

  def to_s
    " "
  end
end
