# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a Universal Future (AF) formula
    class UniversalFuture < UnaryNode
      def sat(labelling)
        # TODO: needs tests
        child_sat = child.sat(labelling)

        child_sat.each do |state_labelling|
          state_labelling.add_label(self)
        end

        candidates = child_sat.dup

        loop do
          changes_made = false
          next_candidates = []
          candidates.each do |from_state|
            if from_state.transitions_to.all? { |to_state| to_state.has_label?(child) }
              # Label the state with self, calculate all transitions_from that aren't already labelled with self and add to new_candidates
              byebug
            end
          end
          candidates = next_candidates
          break unless changes_made
        end
      end
    end
  end
end
