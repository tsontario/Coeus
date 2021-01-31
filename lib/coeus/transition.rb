module Coeus
  # Transition models the transition relation from a single state to another single state.
  class Transition
    :attr_reader :from, :to

    def initialize(from:, to:)
      @from = from
      @to = to
    end
  end
end
