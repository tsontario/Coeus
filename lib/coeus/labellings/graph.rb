# frozen_string_literal: true

require 'rgl/dot'
require 'rgl/adjacency'

module Coeus
  module Labellings
    # A thin wrapper class around RGL and the 'dot' tool to generate picture of graphs
    class Graph
      attr_accessor :title

      # Private inner class
      class Vertex
        attr_reader :color, :label, :hash_key

        class << self
          def from_labelling(state_label)
            color = state_label.satisfied ? 'green' : 'red'
            label = state_label
            new(label.state, color)
          end

          def from_state(state)
            label = state
            new(label, nil)
          end
        end

        def initialize(state, color)
          @hash_key = state.name
          @label = html_label(state)
          @color = color
        end

        private

        # State name on top, predicate values listed on bottom
        def html_label(state)
          "<
          <TABLE BORDER=\"0\" CELLBORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"4\" BGCOLOR=\"lightgrey\">
          <TR><TD><FONT POINT-SIZE=\"20.0\">#{state.name}</FONT></TD></TR>
          <TR><TD>#{state.atoms.map(&:value).join(', ')}</TD></TR>
          </TABLE>
          >"
        end
      end
      private_constant :Vertex

      class << self
        private_class_method :new
        def from_labelling(labelling)
          dg = RGL::DirectedAdjacencyGraph.new
          vertex_dict = {}
          # Add states
          labelling.state_labellings.each do |state_label|
            from = Vertex.from_labelling(state_label)
            vertex_dict[from.hash_key] ||= from
            state_label.transitions_to&.each do |to_label|
              to = Vertex.from_labelling(labelling.for(to_label.name))
              vertex_dict[to.hash_key] ||= to
              dg.add_edge(vertex_dict[from.hash_key], vertex_dict[to.hash_key])
            end
          end
          new(dg)
        end

        def from_model(model)
          dg = RGL::DirectedAdjacencyGraph.new
          vertex_dict = {}
          # Add states
          model.states.each do |state|
            from = Vertex.from_state(state)
            vertex_dict[from.hash_key] ||= from
            state.transitions_to&.each do |to_state|
              to = Vertex.from_state(to_state)
              vertex_dict[to.hash_key] ||= to
              dg.add_edge(vertex_dict[from.hash_key], vertex_dict[to.hash_key])
            end
          end
          new(dg)
        end
      end

      def initialize(graph)
        @graph = graph
      end

      def draw!(outfile, graph_options: {}, vertex_options: {})
        options = default_graph_options.merge(graph_options)
        options['vertex'] = default_vertex_options.merge(vertex_options)
        graph.write_to_graphic_file(
          'png',
          outfile,
          options
        )
      end

      def draw_basic!(outfile)
        options = {}
        options['vertex'] = { 'label' => proc { |v| v.label } }
        graph.write_to_graphic_file('png', outfile, options)
      end

      def default_graph_options
        options = {}
        options['label'] = title if title
        options['rankdir'] = '"LR"'
        options
      end

      # vertex_procs returns the default styling options for each kind of vertex. options can be passed in
      # to add new or override existing entries. Due to the nature of the graph drawing library, values must
      # be passed in as Proc objects, with the provided argument assumed to be a vertex
      def default_vertex_options
        {
          'label' => proc { |v| v.label },
          'style' => proc { |_v| 'filled' },
          'color' => proc { |v| v.color }
        }
      end

      private

      attr_reader :graph
    end
  end
end
