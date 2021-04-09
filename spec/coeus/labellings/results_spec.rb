# frozen_string_literal: true

  context 'when partition results' do
    it 'partitions satisfied and unsatisfied nodes of a CTL expression' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/universal_future_test.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = Coeus::Labelling.new(model)
      c1_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
      universal_future_node = Coeus::ParseTree::UniversalFuture.new(child: c1_node)
      parse_tree = Coeus::ParseTree.new(universal_future_node)
      labelling.sat(parse_tree)
      results = Coeus::Labellings::Results.from_labelling(labelling)
      expect(results.satisfied?).to eq(false)
      expect(results.satisfied_states.map(&:name)).to eq(["s1", "s2", "s3"])
      expect(results.unsatisfied_states.map(&:name)).to eq(["s0", "s4", "s5", "s6", "s7"])

      graph = Coeus::Labellings::Graph.from_results(results)
      graph.graph.write_to_graphic_file('png', 'graph', 'vertex' => { 'color' => Proc.new { |v| v.color }})
    end
  end
