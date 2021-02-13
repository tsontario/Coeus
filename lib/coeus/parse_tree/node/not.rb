# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing the NOT operator
    class Not < UnaryNode
      def sat(labelling)
        child.sat(labelling)
        labelling.state_labellings.each do |state_labelling|
          state_labelling.add_label(self) unless state_labelling.has_label?(child)
        end
      end
    end
  end
end
