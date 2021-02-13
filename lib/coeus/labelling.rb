# frozen_string_literal: true

module Coeus
  # A Labelling keeps track of the labels satisfied by a given state
  class Labelling
    attr_accessor :state_labellings

    # StateLabels is a storage container for keeping track of satisfied formula(e) for the associated state
    class StateLabels
      attr_reader :state

      def initialize(state)
        @state = state
      end

      # Labels are nodes of the parse tree
      def add_label(node)
        labels << node
      end

      def labels
        @labels ||= []
      end
    end

    def initialize(model)
      @model = model
      @state_labellings = model.states.map { |state| StateLabels.new(state) }
    end

    # we expect a parse tree here... should validate
    def sat(formula)
      # formula is a tree, can we simply delegate solutioning to the subclasses? Pass down self to access labelling
      formula.sat(self)
    end
  end
end
