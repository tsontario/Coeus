# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing a Universal Future (AF) formula
    class UniversalFuture < UnaryNode
      def sat(labelling)
        child_sat = child.sat(labelling)

        y = child_sat.dup
        loop do
          x = y.dup
          y.each do |child_labelling|
            child_labelling.transitions_from&.each do |incoming_state|
              if incoming_state.transitions_to&.all? { |outgoing_state| y.map(&:name).include?(outgoing_state.name) }
                labelled_incoming = labelling.for(incoming_state.name)
                y << labelled_incoming unless y.include?(labelled_incoming)
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
        equal?(other)
      end
    end
  end
end
