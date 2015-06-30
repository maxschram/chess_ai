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

  private

  attr_accessor :grid
  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    grid[row][col] = val
  end

end

class EmptySquare

  def moves
    []
  end

end
