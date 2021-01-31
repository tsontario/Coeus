module Coeus
  # The Model class contains a collection of items which, taken together, define a transition system.
  # In particular, it contains a set of states, a set of transitions _between_ states, and a set of labels
  class Model
    attr_reader :states, :transitions, :labels

    def initialize(states:, transitions:, labels: {})
      @states = states
      @transitions = transitions
      @labels = labels
    end

    # sat determines the set of states that satisfy formula
    def sat(formula)
      
    end
  end
end
