# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing the AND operator
    class And < BinaryNode
      def sat(labelling)
        left.sat(labelling)
        right.sat(labelling)
        labelling.state_labellings.each do |state_labelling|
          state_labelling.add_label(self) if state_labelling.has_label?(left) && state_labelling.has_label?(right)
        end
      end
    end
  end
end
