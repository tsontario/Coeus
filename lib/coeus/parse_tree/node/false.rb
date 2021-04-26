# frozen_string_literal: true

module Coeus
  class ParseTree
    # False nodes simply do not label anything
    class False < LeafNode
      def sat(labelling)
        labelling.state_labellings
      end

      def ==(other)
        equal?(other)
      end

      def value
        ''
      end

      def tree_compare(other)
        instance_of?(other.class)
      end
    end
  end
end
