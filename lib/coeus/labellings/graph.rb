# frozen_string_literal: true

require 'rgl/dot'
require 'rgl/adjacency'

module Coeus
  module Labellings
    # A thin wrapper class around RGL and the 'dot' tool to generate picture of graphs
    class Graph
      # TODO set as private inner class
      class Vertex
        attr_reader :color, :label, :hash_key

        class << self
          def from_labelling(state_label)
            color = state_label.satisfied ? 'green' : 'red'
            label = state_label
            new(label, color)
          end
        end

        def initialize(label, color)
          @hash_key = label.name
          @label = html_label(label)
          @color = color
        end  

        private

        def html_label(state_label)
          """<
          <TABLE BORDER=\"0\" CELLBORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"4\" BGCOLOR=\"lightgrey\">
          <TR><TD><FONT POINT-SIZE=\"20.0\">#{state_label.name}</FONT></TD></TR>
          <TR><TD>#{state_label.state.atoms.map(&:value).join(', ')}</TD></TR>
          </TABLE>
          >"""
        end      
      end # End vertex inner class

      class << self
        private_class_method :new
        def from_labelling(labelling)
          dg = RGL::DirectedAdjacencyGraph.new
          vertex_dict = {}
          # Add states
          labelling.state_labellings.each do |state_label|
            from = Vertex.from_labelling(state_label)
            vertex_dict[from.hash_key] ||= from
            state_label.transitions_from.each do |to_label|
              to = Vertex.from_labelling(labelling.for(to_label.name))
              vertex_dict[to.hash_key] ||= to
              dg.add_edge(vertex_dict[from.hash_key], vertex_dict[to.hash_key])
            end
          end
          new(dg)
        end # End Graph metaclass
      end
      
      def initialize(graph)
        @graph = graph
      end
      
      def draw!(graph_options: {}, vertex_options: {})
        options = {}
        options = default_graph_options.merge(graph_options)
        options['vertex'] = default_vertex_options.merge(vertex_options)
        graph.write_to_graphic_file(
          'png',
          'graph',
          options
        )
      end
      
      def default_graph_options
        {}
      end

      # vertex_procs returns the default styling options for each kind of vertex. options can be passed in
      # to add new or override existing entries. Due to the nature of the graph drawing library, values must
      # be passed in as Proc objects, with the provided argument assumed to be a vertex
      def default_vertex_options
        {
          'label' => Proc.new { |v| v.label },
          'style' => Proc.new { |v| 'filled' },
          'color' => Proc.new { |v| v.color }
        }
      end

      private
      attr_reader :graph
    end
  end
end
