# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing the AND operator
    class And < BinaryNode
      def sat(labelling)
        left_sat = left.sat(labelling)
        right_sat = right.sat(labelling)

        labelled = []

        left_sat.intersection(right_sat).each do |state_labelling|
          state_labelling.add_label(self)
          labelled << state_labelling
        end
        labelled
      end
    end
  end
end
