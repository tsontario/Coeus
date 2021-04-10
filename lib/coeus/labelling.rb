# frozen_string_literal: true
require_relative 'labellings/graph'

module Coeus
  # A Labelling keeps track of the labels satisfied by a given formula for all states of a Model
  class Labelling
    Error = Class.new(Coeus::Error)
    SatNotRunError = Class.new(Error)

    attr_reader :model, :result_set

    delegate :states, to: :model
    # StateLabels is a storage container for keeping track of satisfied formula(e) for the associated state
    class StateLabels
      attr_reader :state, :tree
      attr_accessor :satisfied

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

      def satisfied
        @satisfied
      end

      def satisfied=(bool)
        @satisfied = bool
      end

    end

    def initialize(model)
      @model = model
    end

    def state_labellings
      @state_labellings.values || []
    end

    def for(state_name)
      @state_labellings[state_name]
    end

    def sat(tree)
      @tree = tree
      # Always reset state_labellings so we can run different formulae on a given instance
      @state_labellings = model.states.each_with_object({}) { |state, acc| acc[state.name] = StateLabels.new(state) }
      
      # This will update StateLabel objects!
      tree.sat(self)

      # A state satisfies the given expression if it remains labelled after running the sat algorithm
      state_labellings.each { |labelling| labelling.satisfied = labelling.labels.present? }
    end
  
  end
end
