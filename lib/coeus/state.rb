module Coeus
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
