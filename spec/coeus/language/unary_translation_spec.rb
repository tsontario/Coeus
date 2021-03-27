# frozen_string_literal: true

describe Coeus::Language::TranslationParser do
  context 'when evaluating unary operators' do
    it 'Evaluates NOT expression equality' do
      parsed = parser.parse('NOT a')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Not.new(
            child: Coeus::ParseTree::Atomic.new('a')
          )
        )
      )
    end

    it 'Parses EF (universal future) as E(T u PHI)' do
      parsed = parser.parse('EF a')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::ExistsUntil.new(
            left: Coeus::ParseTree::Not.new(
              child: Coeus::ParseTree::False.new),
            right: Coeus::ParseTree::Atomic.new('a')
          )
        )
      )
    end

    it 'Parses AG (universal global) as NOT !E(T u !PHI)' do
      parsed = parser.parse('AG a')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Not.new(
            child: Coeus::ParseTree::ExistsUntil.new(
              left: Coeus::ParseTree::Not.new(
                child: Coeus::ParseTree::False.new),
              right: Coeus::ParseTree::Not.new(
                child: Coeus::ParseTree::Atomic.new('a')
              )
            )
          )
        )
      )
    end

    it 'Parses EG(PHI) as !AF(!PHI)' do
      parsed = parser.parse('EG a')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Not.new(
            child: Coeus::ParseTree::UniversalFuture.new(
              child: Coeus::ParseTree::Not.new(
                child: Coeus::ParseTree::Atomic.new('a')
              )
            )
          )
        )
      )
    end

    it 'Parses AF(PHI) as AF(PHI)' do
      parsed = parser.parse('AF a')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::UniversalFuture.new(
            child: Coeus::ParseTree::Atomic.new('a')
          )
        )
      )
    end

    it 'Parses AX(PHI) as !EX(!PHI)' do
      parsed = parser.parse('AX a')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Not.new(
            child: Coeus::ParseTree::ExistsNext.new(
              child: Coeus::ParseTree::Not.new(
                child: Coeus::ParseTree::Atomic.new('a')
              )
            )
          )
        )
      )
    end

    it 'Parses EX(PHI) as EX(PHI)' do
      parsed = parser.parse('EX a')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::ExistsNext.new(
            child: Coeus::ParseTree::Atomic.new('a')
          )
        )
      )
    end
  end
end
