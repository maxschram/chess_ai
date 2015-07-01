require 'byebug'

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

  def in_check?(color)
    king = find_king(color)
    king_pos = king.pos
    other_color_moves = total_moves_other_color(color)
    other_color_moves.include?(king_pos)
  end

  def find_king(color)
    all_pieces_of_color(color).find { |piece| piece.is_king? }
  end

  def total_moves(color)
    res = []
    all_pieces_of_color(color).each { |piece| res += valid_moves_piece(piece) }
    res
  end

  def total_moves_other_color(color)
    res = []
    color = other_color(color)
    all_pieces_of_color(color).each { |piece| res += valid_moves_piece_other_color(piece)}
    res
  end

  def valid_moves_piece(piece)
    piece.moves.select { |move| valid_move?(piece, move)}
  end

  def valid_moves_piece_other_color(piece)
    piece.moves.select { |move| can_occupy?(piece, move)}
  end

  def all_pieces_of_color(color)
    grid.flatten.select { |piece| !piece.empty? && piece.color == color }
  end

  def other_color(color)
    color == :white ? :black : :white
  end

  def move(start, end_pos)
    self[end_pos] = self[start]
    self[end_pos].move(end_pos)
    self[start] = EmptySquare.new(start)
  end

  def move_puts_in_check?(piece, end_pos)
    taken_piece = self[end_pos]
    start_pos = piece.pos
    move(piece.pos, end_pos)
    check = in_check?(piece.color)
    # place_piece(piece, old_piece_pos)
    # place_piece(taken_piece, move)
    undo_move(piece, taken_piece, start_pos, end_pos)
    check
  end

  def undo_move(piece, old_piece, start_pos, end_pos)
    self[start_pos] = piece
    piece.move(start_pos)
    self[end_pos] = old_piece
    old_piece.move(end_pos)
  end

  # def make_move(piece, old_piece, start_pos, end_pos)
  #   self[start_pos] = EmptySquare.new(start_pos)
  #   old_piece
  # end

  def can_occupy?(piece, pos)
    on_board?(pos) &&
      (self[pos].empty? || piece.color != self[pos].color)
  end

  def checkmate?(color)
    total_moves(color).empty?
  end

  def valid_move?(piece, pos)
    can_occupy?(piece, pos) && !move_puts_in_check?(piece, pos)
  end

  def valid_empty_move?(piece, pos)
    on_board?(pos) && self[pos].empty?
  end

  def valid_take?(piece, pos)
    on_board?(pos) && !self[pos].empty? && piece.color != self[pos].color
  end

  def move_pos(pos, diff)
    pos.zip(diff).map { |dim| dim.reduce(:+) }
  end

  private

  attr_accessor :grid

  def place_piece(piece, pos)
    self[pos] = piece
    self[pos].move(pos)
  end

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
  attr_accessor :pos

  def initialize(pos)
    @pos = pos
  end

  def moves
    []
  end

  def empty?
    true
  end

  def inspect
    " "
  end

  def to_s
    " "
  end

  def is_king?
    false
  end

  def move(pos)
    self.pos = pos
  end
end
