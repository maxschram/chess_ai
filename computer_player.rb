require_relative 'chess_node'

class ComputerPlayer
  attr_reader :color, :board, :game, :plies_ahead
  attr_accessor :selected_pos

  def initialize(color, board, game)
    @color = color
    @board = board
    @game = game
    @plies_ahead = 2
  end

  def take_turn
    next_move
  end

  private

  def random_move
    piece = board.all_pieces_of_color(color).sample
    move = board.valid_moves_piece(piece).sample
    [piece.pos, move]
  end

  def next_move
    root = ChessNode.new(nil, board, color, nil)
    highest_score = alpha_beta(root, plies_ahead, -Float::INFINITY, Float::INFINITY, true)
    move = root.search_move(highest_score)
    move
  end

  def alpha_beta(node, depth, alpha, beta, maximizing_player)
    return node.evaluate if depth == 0 || node.children.empty?

    if maximizing_player == true
      best_value = -Float::INFINITY
      node.children.each do |child|
        child.value = alpha_beta(child, depth - 1, alpha, beta, false)
        best_value = [best_value, child.value].max
        alpha = [alpha, best_value].max
        break if beta <= alpha
      end
      return node.value = best_value
    else
      best_value = Float::INFINITY
      node.children.each do |child|
        child.value = alpha_beta(child, depth - 1, alpha, beta, true)
        best_value = [best_value, child.value ].min
        beta = [beta, best_value].min
        break if beta <= alpha
      end
      return node.value = best_value
    end
  end
end
