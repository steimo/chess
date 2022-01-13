require 'gosu'
require_relative '../lib/square'

describe Square do
  describe '#initialize' do
    context 'when square of a1 initialized' do
      subject(:square) { described_class.new(0, 0) }
      it 'returns a1' do
        position = square.position
        expect(position).to eq('a1')
      end
      context 'when square of h8 initialized' do
        subject(:square) { described_class.new(7, 7) }
        it 'returns h8' do
          position = square.position
          expect(position).to eq('h8')
        end
      end
    end
  end
end
