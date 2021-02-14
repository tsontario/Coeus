# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing the NOT operator
    class True < LeafNode
      def sat(labelling)
        labelling.state_labellings.each do |state_labelling|
          unless state_labelling.has_label?(child)
            state_labelling.add_label(self)
          end
        end
        state_labellings
      end
    end
  end
end
