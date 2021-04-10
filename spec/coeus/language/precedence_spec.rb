# frozen_string_literal: true

describe Coeus::Language::TranslationParser do
  context 'when evaluating precedence rules for CTL expression' do
    it 'set NOT as highest precedence' do
      parsed = parser.parse('NOT a AND b')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::And.new(
            left: Coeus::ParseTree::Not.new(
              child: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
            ),
            right: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
          )
        )
      )
    end

    it 'respects parentheses when using NOT' do
      parsed = parser.parse('NOT(a AND b)')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Not.new(
            child: Coeus::ParseTree::And.new(
              left: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a')),
              right: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
            )
          )
        )
      )
    end
  end
end
