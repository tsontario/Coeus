# frozen_string_literal: true

module Coeus
  # A Labelling keeps track of the labels satisfied by a given formula for all states of a Model
  class Labelling
    attr_reader :model
    attr_accessor :state_labellings

    delegate :states, to: :model
    # StateLabels is a storage container for keeping track of satisfied formula(e) for the associated state
    class StateLabels
      attr_reader :state

      delegate :name, :transitions_from, :transitions_to, to: :state

      def initialize(state)
        @state = state
        state.bind_labelling(self)
      end

      # Labels are just nodes of the parse tree
      def add_label(node)
        labels << node
      end

      def labels
        @labels ||= []
      end

      def has_label?(label)
        labels.include?(label)
      end
    end

    def initialize(model)
      @model = model
      @state_labellings = model.states.map { |state| StateLabels.new(state) }
    end

    def for(state_name)
      state_labellings.find { |state_labelling| state_labelling.name == state_name }
    end

    # we expect a parse tree here... should validate
    def sat(formula)
      # Always reset state_labellings so we can run different formulae on a given instance
      @state_labellings = @model.states.map { |state| StateLabels.new(state) }
      # formula is a tree, can we simply delegate solutioning to the subclasses? Pass down self to access labelling
      formula.sat(self)
    end
  end
end
