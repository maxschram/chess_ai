class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) {EmptySquare.new} }
  end

end

class EmptySquare

  def moves
    []
  end
  
end
