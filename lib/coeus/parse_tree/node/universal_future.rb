# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a Universal Future (AF) formula
    class UniversalFuture < UnaryNode
      def sat(labelling)
        child_sat = child.sat(labelling)

        labelled = []
        y = child_sat.dup
        loop do
          x = y.dup
          y.each do |child_labelling|
            child_labelling.transitions_from&.each do |incoming_state|
              if incoming_state.transitions_to&.all? { |outgoing_state| labelling.for(outgoing_state.name).has_label?(child) }
                labelled_incoming = labelling.for(incoming_state.name)
                y <<  labelled_incoming unless y.include?(labelled_incoming)
              end
            end
          end
          break if x == y
        end

        y.each do |state_labelling|
          state_labelling.add_label(self)
        end
        y
      end

      def ==(other)
        self.object_id == other.object_id
      end
    end
  end
end
