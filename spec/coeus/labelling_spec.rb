# frozen_string_literal: true

describe Coeus::Labelling do
  context 'when evaluating atomic nodes' do
    it 'labels only s0 with state a' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/simple.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      atomic_expression = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
      parse_tree = Coeus::ParseTree.new(atomic_expression)
      labelling.sat(parse_tree)
      s0_labelling = labelling.for('s0')
      s1_labelling = labelling.for('s1')
      expect(s0_labelling.labels).to include(atomic_expression)
      expect(s1_labelling.labels).to be_empty
    end

    it 'labels only s1 with state b' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/simple.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      atomic_expression = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
      parse_tree = Coeus::ParseTree.new(atomic_expression)
      labelling.sat(parse_tree)
      s0_labelling = labelling.for('s0')
      s1_labelling = labelling.for('s1')
      expect(s0_labelling.labels).to be_empty
      expect(s1_labelling.labels).to contain_exactly(atomic_expression)
    end
  end

  context 'when evaluating AND nodes' do
    it 'only label s2 with a AND b' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/for_and_test.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      a_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
      b_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
      and_node = Coeus::ParseTree::And.new(left: a_node, right: b_node)

      parse_tree = Coeus::ParseTree.new(and_node)
      labelling.sat(parse_tree)

      s0_labelling = labelling.for('s0')
      s1_labelling = labelling.for('s1')
      s2_labelling = labelling.for('s2')
      expect(s0_labelling.labels).to contain_exactly(a_node)
      expect(s1_labelling.labels).to contain_exactly(b_node)
      expect(s2_labelling.labels).to contain_exactly(and_node, a_node, b_node)
    end
  end
end
