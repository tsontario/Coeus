# frozen_string_literal: true

module Coeus
  class ParseTree
    # Abstract base class
    class Node
      def initialize(parent: nil)
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

    # A leaf node, e.g. one that has no children
    class LeafNode < Node
      attr_reader :formula

      def initialize(formula, parent: nil)
        super(parent: parent)
        @formula = formula
      end

      def leaf?
        true
      end
    end

    # A node with only a single child
    class UnaryNode < Node
      attr_reader :child

      def initialize(child:, parent: nil)
        super(parent: parent)
        @child = child
      end

      def leaf?
        false
      end
    end

    # A node with exactly 2 children
    class BinaryNode < Node
      attr_reader :left, :right

      def initialize(left:, right:, parent: nil)
        super(parent: parent)
        @left = left
        @right = right
      end

      def leaf?
        false
      end
    end
  end
end
