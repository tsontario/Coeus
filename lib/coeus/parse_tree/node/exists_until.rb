# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a Exists Until (EU) formula
    class ExistsUntil < BinaryNode
      def sat(labelling)
        raise NotImplementedError
      end
    end
  end
end
