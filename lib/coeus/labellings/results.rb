# frozen_string_literal: true

module Coeus
  module Labellings
    # Results provides a read-only interface to the results of a given labelling
    class Results
      attr_reader :satisfied_states, :unsatisfied_states
      
      # Don't allow calling new directly, but only from a labelling
      private_class_method :new

      class << self
        def from_labelling(labelling)
            satisfied_states, unsatisfied_states = labelling.partition_results
            new(satisfied_states: satisfied_states, unsatisfied_states: unsatisfied_states);
        end
      end

      # We actually pass in a Labelling (which delegates to States), but semantically it's probably easier to think
      # of these instance variables as just states without the labelling around them
      def initialize(satisfied_states:, unsatisfied_states:)
        @satisfied_states = satisfied_states
        @unsatisfied_states = unsatisfied_states
      end

      def satisfied?
        @unsatisfied_states.empty?
      end

      def draw_results
        raise NotImplementedError, 'TODO'
      end
    end
  end
end
