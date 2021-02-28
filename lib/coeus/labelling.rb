# frozen_string_literal: true

module Coeus
  # A Labelling keeps track of the labels satisfied by a given formula for all states of a Model
  class Labelling
    attr_reader :model

    delegate :states, to: :model
    # StateLabels is a storage container for keeping track of satisfied formula(e) for the associated state
    class StateLabels
      attr_reader :state

      delegate :name, :transitions_from, :transitions_to, to: :state

      def initialize(state)
        @state = state
        state.bind_labelling(self)
      end

      # Labels are just node references to the parse tree
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
    end

    def state_labellings
      state_labellings.values
    end

    def for(state_name)
      state_labellings[state_name]
    end

    def sat(tree)
      # Always reset state_labellings so we can run different formulae on a given instance
      @state_labellings = model.states.each_with_object({}) { |state, acc| acc[state.name] = StateLabels.new(state) }
      tree.sat(self)
    end
  end
end
