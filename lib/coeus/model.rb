# frozen_string_literal: true

require 'yaml'

require_relative 'state'
require_relative 'transition'
require_relative 'atom'
module Coeus
  # The Model class contains a collection of items which, taken together, define a transition system.
  # In particular, it contains a set of states, a set of transitions _between_ states, and a set of labels
  class Model
    # Do not allow Model instances to be created directly
    private_class_method :new
    class << self
      def from_yaml(yaml)
        # TODO: schema validate
        states = (yaml['states'] || []).map { |s| State.from_yaml(s) }
        transitions = (yaml['transitions'] || []).map { |t| Transition.from_yaml(t, states) }
        model = new(states: states, transitions: transitions)
        model.states.each do |state|
          state.transitions_to = model.transitions_for(state)
          state.transitions_from = transitions.select do |transition|
            transition.to.include?(state)
          end.map(&:from)
        end
        model
      end
    end

    attr_reader :states, :transitions

    def initialize(states:, transitions:)
      @states = states
      @transitions = transitions
    end

    def transitions_for(state)
      transitions.detect { |transition_list| transition_list.from == state }
    end

    def encode_with(coder)
      coder.tag = nil
      coder['states'] = states
      coder['transitions'] = transitions
    end
  end
end
