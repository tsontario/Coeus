# frozen_string_literal: true

module Coeus
  class ParseTree
    # Abstract base class
    class Node
      def sat(labelling)
        raise NotImplementedError
      end

      def value
        raise NotImplementedError
      end

      def leaf?
        raise NotImplementedError
      end

      def ==(other)
        self.class == other.class
      end
    end

    # A leaf node, e.g. one that has no children
    class LeafNode < Node
      def leaf?
        true
      end
    end

    # A node with only a single child
    class UnaryNode < Node
      attr_reader :child

      def initialize(child:)
        super()
        @child = child
      end

      def leaf?
        false
      end
    end

    # A node with exactly 2 children
    class BinaryNode < Node
      attr_reader :left, :right

      def initialize(left:, right:)
        super()
        @left = left
        @right = right
      end

      def leaf?
        false
      end
    end
  end
end
