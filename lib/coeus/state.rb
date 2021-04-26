# frozen_string_literal: true

module Coeus
  # Represents a single state in the model
  class State
    class << self
      def from_yaml(yaml)
        new(
          name: yaml['name'],
          atoms: (yaml['atoms'] || []).map { |a| Atom.new(a) },
          initial: yaml['initial']
        )
      end
    end
    attr_accessor :transitions_to, :transitions_from
    attr_reader :name, :atoms, :labelling

    def initialize(name:, atoms:, initial: false)
      @name = name
      @atoms = atoms
      @initial = initial || false
    end

    def initial_state?
      @initial
    end

    def bind_labelling(labelling)
      @labelling = labelling
    end

    def ==(other)
      name == other.name &&
        atoms.sort == other.atoms.sort &&
        initial_state? == other.initial_state?
    end

    def encode_with(coder)
      coder.tag = nil
      coder['name'] = name
      coder['initial'] = true if initial_state?
      coder['atoms'] = (atoms || []).map(&:value)
    end
  end
end
