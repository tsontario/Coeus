# frozen_string_literal: true

module Coeus
  # Transition models the transition relation from a single state to another single state.
  class Transition
    class << self
      # We must pass in states since we expect them to be defined prior to enumerating the transitions and want
      # to maintain an reference via this object
      def from_yaml(yaml, states)
        from = states.find { |s| s.name == yaml['from'] }
        to = states.find { |s| s.name == yaml['to'] }
        Transition.new(from: from, to: to)
      end
    end
    attr_reader :from, :to

    def initialize(from:, to:)
      unless [from, to].all? { |arg| arg.is_a?(State) }
        raise ArgumentError, "Transition constructor must be given State objects but got: #{from.class}, #{to.class}"
      end

      @from = from
      @to = to
    end

    def ==(other)
      from == other.from &&
        to == other.to
    end
  end
end
