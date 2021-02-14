# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing an Exists Next State (EX) formula
    class ExistsNext < UnaryNode
      def sat(labelling)
        child_sat = child.sat(labelling)

        child_sat.map(&:transitions_from).flatten.map(&:labelling).each do |from_state|
          labelling.for(from_state.name).add_label(self)
        end
      end
    end
  end
end
