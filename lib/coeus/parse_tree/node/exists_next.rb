# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing an Exists Next State (EX) formula
    class ExistsNext < UnaryNode
      def sat(labelling)
        child.sat(labelling)

        # Go through all states and label them with this node if any of their transitions are labeled with child
        model = labelling.model
        model.states.select do |from_state|
          model.transitions_for(from_state).each do |to_state|
            labelling.for(from_state.name).add_label(self) if labelling.for(to_state.name).has_label?(child)
          end
        end
      end
    end
  end
end
