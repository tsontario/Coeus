# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing an Exists Next State (EX) formula
    class ExistsNext < UnaryNode
      def sat(labelling)
        raise NotImplementedError
      end
    end
  end
end
