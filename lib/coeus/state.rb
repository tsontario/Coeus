# frozen_string_literal: true

module Coeus
  # Represents a single state in the model
  class State
    attr_reader :atoms

    def initialize(atoms)
      @atoms = atoms
    end

    # alias atoms
    def labels
      @atoms
    end
  end
end
