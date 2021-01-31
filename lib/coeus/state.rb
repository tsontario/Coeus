# frozen_string_literal: true

module Coeus
  # Represents a single state in the model
  class State
    attr_reader :name, :atoms

    def initialize(name:, atoms:, initial: false)
      @name = name
      @atoms = atoms
      @initial = initial || false
    end

    def initial_state?
      @initial
    end

    # TODO: test
    def ==(other)
      name == other.name &&
      atoms == other.atoms &&
      initial_state? == other.initial_state?
    end
  end
end
