# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a single predicate value
    class Atomic < LeafNode
      attr_reader :value

      def initialize(value)
        super()
        @value = value
      end

      def sat(labelling)
        labelled = []
        labelling.state_labellings.each do |state_labelling|
          if state_labelling.state.atoms.include?(value)
            state_labelling.add_label(self)
            labelled << state_labelling
          end
        end
        labelled
      end

      def ==(other)
        self.class == other.class && value == other.value
      end

      def tree_compare(other)
        self == other
      end
    end
  end
end
