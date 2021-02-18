# frozen_string_literal: true

def parser
  @parser ||= Coeus::Language::CTLParse.new(Coeus::Language::CTLLex.new)
end

describe Coeus::Language::CTLParse do
  context 'when evaluating unary operators' do
    it 'Evaluates NOT expression equality' do
      parsed = parser.parse('NOT a')
      expect(parsed).to eq(Coeus::ParseTree.new(Coeus::ParseTree::Not.new(child: Coeus::ParseTree::Atomic.new('a'))))
    end
  end
end
