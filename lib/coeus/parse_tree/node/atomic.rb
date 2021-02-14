# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a single predicate value. Atomics are always leaf nodes.
    class Atomic < LeafNode
      def sat(labelling)
        labelling.state_labellings.each do |state_labelling|
          state_labelling.add_label(self) if state_labelling.state.atoms.include?(value)
        end
      end
    end
  end
end
