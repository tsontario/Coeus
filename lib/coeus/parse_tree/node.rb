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
        raise NotImplementedError
      end

      def pretty_print
        _pretty_print(0)
      end

      def to_s
        self.class.to_s.split('::').last
      end

      def _pretty_print(indent)
        puts ' ' * indent + to_s
      end

      # Comparing at the tree level is different than comparing at the node level (such as when running sat)
      # In the latter case, it is important to keep track of the individual object (via ID, e.g.). However,
      # at the tree level, we need to use a coarser idea of equality
      def tree_compare(other)
        raise NotImplementedError
      end
    end

    # A leaf node, e.g. one that has no children
    class LeafNode < Node
      def leaf?
        true
      end

      def _pretty_print(indent)
        puts ' ' * indent + "#{self}:#{value}"
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

      def _pretty_print(indent)
        super
        child._pretty_print(indent + 2)
      end

      def tree_compare(other)
        instance_of?(other.class)
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

      def _pretty_print(indent)
        super
        left._pretty_print(indent + 2)
        right._pretty_print(indent + 2)
      end

      def ==(other)
        self.class == other.class
      end

      def tree_compare(other)
        instance_of?(other.class)
      end
    end
  end
end
