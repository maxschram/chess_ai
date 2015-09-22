class ChessNode
  attr_accessor :parent, :board, :maximizing_player, :value, :previous_move, :current_player, :child_nodes

  def initialize(parent = nil, board, current_player, previous_move)
    @parent = parent
    @board = board
    @current_player = current_player
    @child_nodes = []
    @value = nil
    @previous_move = previous_move
  end

  def search_move(target)
    child_nodes.each do |child|
      if child.value == target
        return child.previous_move
      end
    end
    return nil
  end

  def evaluate
    if board.checkmate?(board.other_color(current_player))
      return Float::INFINITY
    elsif board.checkmate?(current_player)
      return -Float::INFINITY
    end

    200 * king_difference +
    9 * queen_difference +
    5 * rook_difference +
    3 * bishop_and_knight_difference +
    1 * pawn_difference +
    -0.5 * pawn_score +
    0.1 * mobility_score
  end

  def king_difference
    current_player_kings = board.all_pieces_of_color(current_player).select { |piece| piece.is_a?(King) }
    other_player_kings = board.all_pieces_of_color(board.other_color(current_player)).select { |piece| piece.is_a?(King) }
    current_player_kings.count - other_player_kings.count
  end

  def queen_difference
    current_player_queens = board.all_pieces_of_color(current_player).select { |piece| piece.is_a?(Queen) }
    other_player_queens = board.all_pieces_of_color(board.other_color(current_player)).select { |piece| piece.is_a?(Queen) }
    current_player_queens.count - other_player_queens.count
  end

  def rook_difference
    current_player_rooks = board.all_pieces_of_color(current_player).select { |piece| piece.is_a?(Rook) }
    other_player_rooks = board.all_pieces_of_color(board.other_color(current_player)).select { |piece| piece.is_a?(Rook) }
    current_player_rooks.count - other_player_rooks.count
  end

  def bishop_and_knight_difference
    current_player_bishops_and_knights = board.all_pieces_of_color(current_player).select { |piece| piece.is_a?(Bishop) || piece.is_a?(Knight) }
    other_player_bishops_and_knights = board.all_pieces_of_color(board.other_color(current_player)).select { |piece| piece.is_a?(Bishop) || piece.is_a?(Knight) }
    current_player_bishops_and_knights.count - other_player_bishops_and_knights.count
  end

  def pawn_difference
    current_player_pawns = board.all_pieces_of_color(current_player).select { |piece| piece.is_a?(Pawn) }
    other_player_pawns = board.all_pieces_of_color(board.other_color(current_player)).select { |piece| piece.is_a?(Pawn) }
    current_player_pawns.count - other_player_pawns.count
  end

  def pawn_score
    current_player_pawns = board.all_pieces_of_color(current_player).select { |piece| piece.is_a?(Pawn) }
    other_player_pawns = board.all_pieces_of_color(board.other_color(current_player)).select { |piece| piece.is_a?(Pawn) }
    isolated_pawns = current_player_pawns.count{ |pawn| board.isolated_pawn?(pawn)} -
      other_player_pawns.count{ |pawn| board.isolated_pawn?(pawn) }
    doubled_pawns = current_player_pawns.count { |pawn| board.doubled_pawn?(pawn) } -
      other_player_pawns.count { |pawn| board.doubled_pawn?(pawn) }
    blocked_pawns = current_player_pawns.count { |pawn| board.blocked_pawn?(pawn) } -
      other_player_pawns.count { |pawn| board.blocked_pawn?(pawn) }

    isolated_pawns + doubled_pawns + blocked_pawns
  end

  def mobility_score
    board.total_moves(current_player).count - board.total_moves_other_color(current_player).count
  end

  def children
    self.child_nodes = []
    board.all_pieces_of_color(current_player).each do |piece|
      board.valid_moves_piece(piece).each do |move|
        duped_board = board.deep_dup
        duped_board.move(piece.pos, move)
        new_node = ChessNode.new(
          self, duped_board, board.other_color(current_player), [piece.pos, move])
        child_nodes << new_node
      end
    end
    child_nodes.shuffle!
  end
end
