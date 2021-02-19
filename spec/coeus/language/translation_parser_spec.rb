# frozen_string_literal: true

def parser
  @parser ||= Coeus::Language::TranslationParser.new(Coeus::Language::CTLLex.new)
end

describe Coeus::Language::TranslationParser do
  context 'when evaluating unary operators' do
    it 'Evaluates NOT expression equality' do
      parsed = parser.parse('NOT a')
      expect(parsed).to eq(Coeus::ParseTree.new(Coeus::ParseTree::Not.new(child: Coeus::ParseTree::Atomic.new('a'))))
    end
  end
end
