# frozen_string_literal: true

describe Coeus::Language::TranslationParser do
  context 'when evaluating atomic expressions' do
    it 'Parses atomic expressions as atomic nodes' do
      parsed = parser.parse('a')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Atomic.new('a')
        )
      )
    end

    it 'Parses multi-value atomic expressions as a single atomic node' do
      parsed = parser.parse('abc123')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Atomic.new('abc123')
        )
      )
    end
  end
end
