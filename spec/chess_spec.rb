require 'pgn'
require 'gosu'
require_relative '../lib/square'
require_relative '../lib/position'
require_relative '../lib/move'
require_relative '../lib/board'

def coord(move)
  a = (move[0]).ord - 'a'.ord # => 4
  b = (move[1]).ord - 7 - '1'.ord # => -6
  [a, b.abs]
end


describe Board do
  describe 'move' do
    it 'should return new board' do
      from = coord('e2')
      to = coord('e4')
      from_x = from[0]
      from_y = from[1]
      board = Board.new(PGN::FEN.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'))
      position = Position.new(Square.new(from[0], from[1], '♙'), Square.new(to[0], to[1], ''))
      move = board.move(position)
      expect(move.fen.to_s).to eq('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1')
    end
  end
end
