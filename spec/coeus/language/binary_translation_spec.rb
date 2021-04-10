# frozen_string_literal: true

describe Coeus::Language::TranslationParser do
  context 'when evaluating binary operators' do
    it 'Parses (a AND b) as (a AND b)' do
      parsed = parser.parse('a AND b')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::And.new(
            left: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a')),
            right: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
          )
        )
      )
    end

    it 'Parses (a OR b) as !(!a AND !b)' do
      parsed = parser.parse('a OR b')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Not.new(
            child: Coeus::ParseTree::And.new(
              left: Coeus::ParseTree::Not.new(
                child: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
              ),
              right: Coeus::ParseTree::Not.new(
                child: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
              )
            )
          )
        )
      )
    end

    it 'Parses (a -> b) as !(a ^ !b)' do
      parsed = parser.parse('a -> b')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::Not.new(
            child: Coeus::ParseTree::And.new(
              left: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a')),
              right: Coeus::ParseTree::Not.new(
                child: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
              )
            )
          )
        )
      )
    end

    it 'Parses E[a U b] as E[a U b]' do
      parsed = parser.parse('E[a U b]')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::ExistsUntil.new(
            left: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a')),
            right: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
          )
        )
      )
    end

    it 'Parses A[a U b] as (E[~b U (~a AND ~b)] AND ~AF(b)' do
      parsed = parser.parse('A[a U b]')
      expect(parsed).to eq(
        Coeus::ParseTree.new(
          Coeus::ParseTree::And.new(
            left: Coeus::ParseTree::Not.new(
              child: Coeus::ParseTree::ExistsUntil.new(
                left: Coeus::ParseTree::Not.new(
                  child: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
                ),
                right: Coeus::ParseTree::And.new(
                  left: Coeus::ParseTree::Not.new(
                    child: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
                  ),
                  right: Coeus::ParseTree::Not.new(
                    child: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
                  )
                )
              )
            ),
            right: Coeus::ParseTree::UniversalFuture.new(
              child: Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
            )
          )
        )
      )
    end
  end
end
