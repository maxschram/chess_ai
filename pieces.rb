class Piece
  attr_reader :color, :board
  attr_accessor :moved, :pos
  attr_writer :board

  PIECE_CODES = {
      king: "\u265A",
      queen: "\u265B",
      rook: "\u265C",
      bishop: "\u265D",
      knight: "\u265E",
      pawn: "\u265F"
  }
  def initialize(pos, board, color, moved = false)
    @pos = pos
    @board = board
    @color = color
    @moved = moved
  end

  def valid_move?(pos)
    moves.include?(pos)
  end

  def inspect
    "#{color} #{self.class}"
  end

  def is_king?
    false
  end

  def moves
    raise "not yet implemented"
  end

  def move(pos)
    self.pos = pos.dup
  end

  def moved!
    self.moved = true
  end

  def empty?
    false
  end

  def to_s
    piece_name = self.class.to_s.downcase.to_sym
    PIECE_CODES[piece_name].colorize(color)
  end

  def dup
    Piece.new(pos.dup, board, color)
  end
end

class SlidingPiece < Piece
  def moves
    res = []
    move_dirs.each { |dir| res += slide(dir) }
    res
  end

  def slide(dir)
    res = []
    (1..7).to_a.each do |multiplier|
      diff = dir.map { |dim| dim * multiplier}
      next_pos = board.move_pos(pos, diff)
      break unless board.can_occupy?(self, next_pos)
      res << next_pos
      break if board.valid_take?(self, next_pos)
    end

    res
  end
end

class SteppingPiece < Piece
  def moves
    res = []
    steps.each do |step|
      next_pos = board.move_pos(pos, step)
      res << next_pos if board.can_occupy?(self, next_pos)
    end

    res
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
    [1, -1].repeated_permutation(2).to_a.concat([[1, 0], [0, 1], [-1, 0], [0, -1]])
  end
end

class Knight < SteppingPiece
  def steps
    [1, -1, 2, -2].repeated_permutation(2).select { |move| move.first.abs != move.last.abs }
  end
end

class King < SteppingPiece
  def steps
    [1, -1, 0].repeated_permutation(2).to_a
  end

  def is_king?
    true
  end
end

class Pawn < Piece
  ADVANCE_1 = [1,0]
  ADVANCE_2 = [2,0]
  TAKE = [[1,1], [1, -1]]

  def moves
    res = []
    move_diffs.each do |move|
      next_pos = board.move_pos(pos, move)
      break unless board.valid_empty_move?(self, next_pos)
      res << next_pos
    end

    take_diffs.each do |move|
      next_pos = board.move_pos(pos, move)
      res << next_pos if board.valid_take?(self, next_pos)
    end

    res
  end

  def move_diffs
    if color == :white
      up_diffs
    else
      down_diffs
    end
  end

  def take_diffs
    if color == :white
      up_take_diffs
    else
      down_take_diffs
    end
  end

  def down_diffs
    moved ? [ADVANCE_1] : [ADVANCE_1,  ADVANCE_2]
  end

  def up_diffs
    down_diffs.map { |diff| [diff.first * -1, diff.last * -1]}
  end

  def down_take_diffs
    TAKE
  end

  def up_take_diffs
    down_take_diffs.map { |diff| [diff.first * -1, diff.last * -1]}
  end
end
