# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing an Exists Next State (EX) formula
    class ExistsNext < UnaryNode
      def sat(labelling)
        child_sat = child.sat(labelling)

        model = labelling.model
        model.states.select do |from_state|
          model.transitions_for(from_state).each do |to_state|
            if labelling.for(to_state.name).has_label?(child)
              labelling.for(from_state.name).add_label(self)
              break
            end
          end
        end
      end
    end
  end
end
