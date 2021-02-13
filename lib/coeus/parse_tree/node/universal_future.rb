# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a Universal Future (AF) formula
    class UniversalFuture < UnaryNode
      def sat(labelling)
        raise NotImplementedError
      end
    end
  end
end
