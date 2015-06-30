class Piece

  attr_reader :color, :pos

  PIECE_CODES = {
    white: {
      king: "\u2654",
      queen: "\u2655",
      rook: "\u2656",
      bishop: "\u2657",
      knight: "\u2658",
      pawn: "\u2659"
    },
    black: {
      king: "\u265A",
      queen: "\u265B",
      rook: "\u265C",
      bishop: "\u265D",
      knight: "\u265E",
      pawn: "\u265F"
    }
  }
  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color

  end

  def moves
    raise "not yet implemented"
  end

  def empty?
    false
  end

  def to_s
    piece_name = self.class.to_s.downcase.to_sym
    PIECE_CODES[color][piece_name].colorize(color)
  end

  private

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
    [1, -1].repeated_permutation(2).to_a
  end
end

class Rook < SlidingPiece

  def move_dirs
    [[1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end

class Queen < SlidingPiece

  def move_dirs
    raise "not yet implemented"
  end
end

class Knight < SteppingPiece
end

class King < SteppingPiece
end

class Pawn < Piece
end
