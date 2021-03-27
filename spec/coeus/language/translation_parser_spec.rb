# frozen_string_literal: true

module Coeus

  describe Language::TranslationParser do
    context 'when evaluating unary operators' do
      it 'Evaluates NOT expression equality' do
        parsed = parser.parse('NOT a')
        expect(parsed).to eq(ParseTree.new(ParseTree::Not.new(child: ParseTree::Atomic.new('a'))))
      end
    end
  end
end