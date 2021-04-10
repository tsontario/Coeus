# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing an Exists Next State (EX) formula
    class ExistsNext < UnaryNode
      def sat(labelling)
        child_sat = child.sat(labelling)

        labelled = []
        child_sat.map(&:transitions_from).flatten.map(&:labelling).each do |from_state|
          labelling.for(from_state.name).add_label(self)
          labelled << from_state
        end
        labelled
      end

      def ==(other)
        self.object_id == other.object_id
      end
    end
  end
end
