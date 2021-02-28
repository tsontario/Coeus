# frozen_string_literal: true

require_relative 'parse_tree/node'
Dir.glob(File.expand_path('parse_tree/node/**/*.rb', __dir__)).sort.each do |file|
  require file
end

module Coeus
  # ParseTree is a tree representing a CTL expression
  class ParseTree
    attr_reader :node

    Error = Class.new(StandardError)

    def initialize(node)
      @node = node
    end

    def sat(labelling)
      node.sat(labelling)
    end

    def ==(other)
      # Simple cases
      return true if node.nil? && other.node.nil?
      return false if node.nil? || other.node.nil?

      case node
      when LeafNode
        return false unless other.node.is_a?(LeafNode)

        node == other.node
      when UnaryNode
        return false unless other.node.is_a?(UnaryNode)
        return false unless node == other.node

        ParseTree.new(node.child) == ParseTree.new(other.node.child)
      when BinaryNode
        return false unless other.node.is_a?(BinaryMode)
        return false unless node == other.node

        ParseTree.new(node.left) == new(other.node.left) &&
          ParseTree.new(node.right) == ParseTree.new(other.node.right)
      else
        raise Error, "Unknown node class #{node&.class}"
      end
    end
  end
end
