# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a Universal Future (AF) formula
    class UniversalFuture < UnaryNode
      def sat(labelling)
        # TODO: needs tests
        child.sat(labelling)

        labelling.state_labellings.each do |state_labelling|
          state_labelling.add_label(self) if state_labelling.has_label?(child)
        end

        model = labelling.model
        candidates = model.states.dup
        loop do
          changes_made = false
          candidates.each do |from_state|
            from_state_labelling = labelling.for(from_state.name)
            if from_state_labelling.has_label?(self) # Otherwise we will keep labelling the same node(s) ad infinitum
              candidates -= [from_state]
              next
            end
            next unless from_state_labelling.has_label?(child) && model.transitions_for(from_state).all? do |to_state|
                          labelling.for(to_state.name).has_label?(self)
                        end

            from_state_labelling.add_label(self)
            changes_made = true
          end
          break unless changes_made
        end
      end
    end
  end
end
