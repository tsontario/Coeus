# frozen_string_literal: true

require_relative 'parse_tree/node'
Dir.glob(File.expand_path('parse_tree/node/**/*.rb', __dir__)).sort.each do |file|
  require file
end

module Coeus
  # ParseTree is a tree representing a CTL expression
  class ParseTree
    def initialize(node)
      @node = node
    end

    def sat(labelling)
      @node.sat(labelling)
    end
  end
end
