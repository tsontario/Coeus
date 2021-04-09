# frozen_string_literal: true

require 'rgl/dot'
require 'rgl/adjacency'

module Coeus
  module Labellings
    class Vertex
      attr_reader :color
      def initialize(name, color)
        @name = name
        @color = color
      end
    end

    # A thin wrapper class around RGL and the 'dot' tool to generate picture of graphs
    class Graph
      class << self
        private_class_method :new
        def from_results(results)
          dg = RGL::DirectedAdjacencyGraph.new
          1.upto(10) do |i|
            a = Vertex.new('a' + i.to_s, 'blue')
            b = Vertex.new('b' + i.to_s, 'red')
            dg.add_edge(a, b)
          end
          new(dg)
        end
      end
      # TODO remove
      attr_reader :graph

      def initialize(graph)
        @graph = graph
      end

      def draw!
        dg.write_to_graphic_file('png', 'graph', 'vertex' => { 'color' => Proc.new do |v|
          v.color
        end})
      end
    end
  end
end
