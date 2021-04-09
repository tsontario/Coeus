# frozen_string_literal: true

require 'rgl/dot'
require 'rgl/adjacency'

module Coeus
  module Labellings
    # TODO set as private inner class
    class Vertex
      attr_reader :color, :label
      def initialize(label, color)
        @label = label
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
      
      def initialize(graph)
        @graph = graph
      end
      
      def draw!
        graph.write_to_graphic_file('png', 'graph', 'vertex' => vertex_procs)
      end
      
      # vertex_procs returns the default styling options for each kind of vertex. options can be passed in
      # to add new or override existing entries. Due to the nature of the graph drawing library, values must
      # be passed in as Proc objects, with the provided argument assumed to be a vertex
      def vertex_procs(options={})
        {
          'label' => Proc.new { |v| v.label },
          'color' => Proc.new { |v| v.color }
        }.merge(options)
      end

      private
      attr_reader :graph
    end
  end
end
