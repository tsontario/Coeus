# frozen_string_literal: true

module Coeus
  # Atom represents a predicate value that is considered true when present in a State object
  class Atom
    include Comparable
    attr_reader :value

    def initialize(value)
      @value = value
    end

    # TODO: test
    def <=>(other)
      value <=> other.value
    end
  end
end
