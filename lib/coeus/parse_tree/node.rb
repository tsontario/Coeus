# frozen_string_literal: true

module Coeus
  class ParseTree
    # Abstract base class
    class Node
      attr_reader :formula

      def initialize(formula, parent: nil)
        @formula = formula
        @parent = parent
      end

      def sat(labelling)
        raise NotImplementedError
      end

      def value
        raise NotImplementedError
      end

      private

      attr_accessor :parent, :left, :right

      def leaf?
        raise NotImplementedError
      end
    end
  end
end
