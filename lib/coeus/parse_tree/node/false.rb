# frozen_string_literal: true

module Coeus
  class ParseTree
    # False nodes simply do not label anything
    class False < LeafNode
      def sat(labelling)
        labelling.state_labellings
      end

      def ==(other)
        self.object_id == other.object_id
      end

      def value
        ''
      end

      def tree_compare(other)
        self.class == other.class
      end
    end
  end
end
