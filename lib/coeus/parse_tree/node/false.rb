# frozen_string_literal: true

module Coeus
  class ParseTree
    # False nodes simply do not label anything
    class False < LeafNode
      def sat(labelling)
        labelling.state_labellings
      end
    end
  end
end
