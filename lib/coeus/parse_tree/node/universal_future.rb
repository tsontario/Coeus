# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a Universal Future (AF) formula
    class UniversalFuture < UnaryNode
      def sat(labelling)
        child_sat = child.sat(labelling)

        labelled = []
        child_sat.each do |state_labelling|
          state_labelling.add_label(self)
          labelled << state_labelling
        end

        candidates = child_sat.flat_map do |state_labelling|
          state_labelling.transitions_from.map(&:labelling)
        end

        loop do
          changes_made = false
          next_candidates = []
          candidates.each do |from_state|
            if from_state.has_label?(self)
              candidates -= [from_state]
              next
            end

            next unless from_state.transitions_to.map(&:labelling).all? { |to_state| to_state.has_label?(self) }

            from_state.add_label(self)
            labelled << from_state
            (next_candidates += from_state.transitions_from.map(&:labelling)).uniq
            changes_made = true
          end
          candidates = next_candidates
          break unless changes_made
        end
        labelled
      end
    end
  end
end
