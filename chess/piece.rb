class Piece

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def moves
    raise "not yet implemented"
  end
end

class SlidingPiece < Piece

  def moves
    raise "not yet implemented"
  end
end

class SteppingPiece < Piece

  def moves
    raise "not yet implemented"
  end
end

class Bishop < SlidingPiece

  def move_dirs
    raise "note yet implemented"
  end
end

class Rook < SlidingPiece

  def move_dirs
    raise "note yet implemented"
  end
end

class Queen < SlidingPiece

  def move_dirs
    raise "note yet implemented"
  end
end
