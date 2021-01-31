# frozen_string_literal: true

require 'yaml'

require_relative 'state'
require_relative 'transition'
require_relative 'atom'
module Coeus
  # The Model class contains a collection of items which, taken together, define a transition system.
  # In particular, it contains a set of states, a set of transitions _between_ states, and a set of labels
  class Model
    class << self
      # Do not allow Model instances to be created directly
      private_class_method :new

      def from_yaml(yaml)
        # TODO: schema validate
        states = (yaml['states'] || []).map { |s| State.from_yaml(s) }
        transitions = (yaml['transitions'] || []).map { |t| Transition.from_yaml(t, states) }
        new(states: states, transitions: transitions)
      end
    end

    attr_reader :states, :transitions

    def initialize(states:, transitions:)
      @states = states
      @transitions = transitions
    end

    # sat determines the set of states that satisfy formula
    def sat(formula)
      # TODO: implement CTL algorithm
    end
  end
end
