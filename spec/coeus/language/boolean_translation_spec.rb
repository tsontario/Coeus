# frozen_string_literal: true

describe Coeus::Language::TranslationParser do
  context 'when evaluating boolean literals' do
    it 'Parses true as NOT false' do
      parsed = parser.parse('true')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Not.new(
            child: Coeus::ParseTree::False.new
          )
        )
      )
    end

    it 'Parses false as false' do
      parsed = parser.parse('false')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::False.new
        )
      )
    end

    it 'Parses boolean terms without case sensitivity' do
      parsed = parser.parse('TRUE')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Not.new(
            child: Coeus::ParseTree::False.new
          )
        )
      )

      parsed = parser.parse('FALSE')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::False.new
        )
      )
    end
  end
end
