require 'gosu'
require 'pry'
require_relative '../lib/square'
require_relative '../lib/board'
require_relative '../lib/chess_helper'
require_relative '../states/game_state'
require_relative '../states/play_state'
include ChessHelper

describe PlayState do
  context '.new' do
    it { expect(subject.board[e4]).to eq nil }
    it { expect(subject.board[e2]).to eq 'P' }
    it { expect(subject.board[d1]).to eq 'Q' }
    it { expect(subject.board[d8]).to eq 'q' }
    it { expect(subject.turn).to eq(:white) }
    it { expect(subject.castling).to eq('KQkq') }
    it { expect(subject.ep).to be_nil }
    it { expect(subject.halfmove).to eq(0) }
    it { expect(subject.fullmove).to eq(1) }
    it { expect(subject.king).to eq({ white: e1, black: e8 }) }
  end
  context '#move' do
    context 'e4' do
      subject { PlayState.new.move('e4') }
      it { expect(subject.board[e4]).to eq 'P' }
      it { expect(subject.board[e2]).to eq nil }
      it { expect(subject.turn).to eq :black }
      it { expect(subject.castling).to eq('KQkq') }
      it { expect(subject.ep).to e3 }
      it { expect(subject.halfmove).to eq(0) }
      it { expect(subject.fullmove).to eq(1) }
    end
  end
end

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
