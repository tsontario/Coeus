# frozen_string_literal: true
require_relative 'labellings/results'
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
      @state_labellings.values || []
    end

    def for(state_name)
      @state_labellings[state_name]
    end

    def sat(tree)
      # Maintain a reference to the parse tree
      @tree = tree
      # Always reset state_labellings so we can run different formulae on a given instance
      @state_labellings = model.states.each_with_object({}) { |state, acc| acc[state.name] = StateLabels.new(state) }
      @result_set = tree.sat(self)
    end

    def partition_results
      raise SatNotRunError, 'You must run the SAT algorithm before attempting to parse results' unless result_set.present?
      satisfied, unsatisfied = state_labellings.partition { |labelling| labelling.labels.present? }
    end

    private
    
    attr_reader :tree, :result_set
  end
end
