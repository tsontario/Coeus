# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a Exists Until (EU) formula
    # In terms of children, we expect them to be expressed in the form
    # E [ left_child U right_child ]
    class ExistsUntil < BinaryNode
      def sat(labelling)
        left.sat(labelling)
        right.sat(labelling)

        # If the right child is already true, the expression is trivially true for that state
        labelling.state_labellings.each do |state_labelling|
          state_labelling.add_label(self) if state_labelling.has_label?(right)
        end

        # Keep iterating by backfilling states that immediately satisfy the expression.
        # Continue in this manner until no changes occur during an iteration.
        model = labelling.model
        candidates = model.states.dup
        loop do
          changes_made = false
          candidates.each do |from_state|
            from_state_labelling = labelling.for(from_state.name)
            if from_state_labelling.has_label?(self)
              candidates -= [from_state]
              next
            end
            if from_state_labelling.has_label?(left)
              if model.transitions_for(from_state).any? { |to_state| labelling.for(to_state.name).has_label?(self) }
                from_state_labelling.add_label(self)
                changes_made = true
              end
            end
          end
          break unless changes_made
        end
      end
    end
  end
end
