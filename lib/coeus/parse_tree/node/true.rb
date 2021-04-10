# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a TRUE expression
    class True < LeafNode
      def sat(labelling)
        labelling.state_labellings.each do |state_labelling|
          state_labelling.add_label(self)
        end
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
