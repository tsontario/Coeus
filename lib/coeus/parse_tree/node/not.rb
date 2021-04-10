# frozen_string_literal: true

module Coeus
  class ParseTree
    # A ParseTree node representing the NOT operator
    class Not < UnaryNode
      def sat(labelling)
        child.sat(labelling)
        labelled = []
        labelling.state_labellings.each do |state_labelling|
          unless state_labelling.has_label?(child)
            state_labelling.add_label(self)
            labelled << state_labelling
          end
        end
        labelled
      end

      def ==(other)
        self.object_id == other.object_id
      end
    end
  end
end
