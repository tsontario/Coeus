# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a Exists Until (EU) formula
    # In terms of children, we expect them to be expressed in the form
    # E [ left_child U right_child ]
    class ExistsUntil < BinaryNode
      def sat(labelling)
        left_sat = left.sat(labelling)
        right_sat = right.sat(labelling)

        right_sat.each.each do |state_labelling|
          state_labelling.add_label(self)
        end

        backfill(labelling, left_sat)
      end

      private

      # Consider states that satisfy :left
      # Continue in this manner until no changes occur during an iteration.
      def backfill(labelling, candidates)
        model = labelling.model
        loop do
          changes_made = false
          candidates.map(&:state).each do |from_state|
            from_state_labelling = labelling.for(from_state.name)
            if from_state_labelling.has_label?(self)
              candidates -= [from_state]
              next
            end
            next unless from_state_labelling.has_label?(left) && model.transitions_for(from_state).any? do |to_state|
                          labelling.for(to_state.name).has_label?(self)
                        end

            from_state_labelling.add_label(self)
            (candidates += from_state.transitions_from.map(&:labelling)).uniq
            changes_made = true
          end
          break unless changes_made
        end
      end
    end
  end
end
