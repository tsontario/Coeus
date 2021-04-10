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

  context 'when evaluating NOT nodes' do
    it 'labels only s1 with state NOT a' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/simple.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      a_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
      not_node = Coeus::ParseTree::Not.new(child: a_node)
      parse_tree = Coeus::ParseTree.new(not_node)
      labelling.sat(parse_tree)
      s0_labelling = labelling.for('s0')
      s1_labelling = labelling.for('s1')
      expect(s0_labelling.labels).to contain_exactly(a_node)
      expect(s1_labelling.labels).to contain_exactly(not_node)
    end

    # NOTE: This is a little tricky, since the way this is evaluated means the odd-numbered NOT
    # node will NOT be present in the resulting labels. This is consistent with the CTL labelling algorithm,
    # but bears mentioning to avoid confusion.
    it 'allows double negations' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/simple.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      a_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
      not_node = Coeus::ParseTree::Not.new(child: a_node)
      another_not_node = Coeus::ParseTree::Not.new(child: not_node)
      parse_tree = Coeus::ParseTree.new(another_not_node)
      labelling.sat(parse_tree)
      s0_labelling = labelling.for('s0')
      s1_labelling = labelling.for('s1')
      expect(s0_labelling.labels).to contain_exactly(another_not_node, a_node)
      expect(s1_labelling.labels).to contain_exactly(not_node)
    end
  end

  context 'when evaluating NOT AND expressions' do
    it 'labels s1 with AND NOT a b' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/for_and_test.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      a_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
      b_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
      not_a_node = Coeus::ParseTree::Not.new(child: a_node)
      and_node = Coeus::ParseTree::And.new(left: not_a_node, right: b_node)
      parse_tree = Coeus::ParseTree.new(and_node)
      labelling.sat(parse_tree)
      s0_labelling = labelling.for('s0')
      s1_labelling = labelling.for('s1')
      s2_labelling = labelling.for('s2')
      expect(s0_labelling.labels).to contain_exactly(a_node)
      expect(s1_labelling.labels).to include(and_node)
      expect(s2_labelling.labels).to contain_exactly(a_node, b_node)
    end

    it 'labels s0, s1 with NOT AND a b' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/for_and_test.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      a_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
      b_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
      and_node = Coeus::ParseTree::And.new(left: a_node, right: b_node)
      not_node = Coeus::ParseTree::Not.new(child: and_node)
      parse_tree = Coeus::ParseTree.new(not_node)
      labelling.sat(parse_tree)
      s0_labelling = labelling.for('s0')
      s1_labelling = labelling.for('s1')
      s2_labelling = labelling.for('s2')
      expect(s0_labelling.labels).to contain_exactly(a_node, not_node)
      expect(s1_labelling.labels).to contain_exactly(b_node, not_node)
      expect(s2_labelling.labels).to contain_exactly(a_node, b_node, and_node)
    end
  end

  context 'when evaluating exists next expressions' do
    it 'labels s0 and s1 with EX b' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/for_exists_next_test.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      b_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
      exists_next_node = Coeus::ParseTree::ExistsNext.new(child: b_node)
      parse_tree = Coeus::ParseTree.new(exists_next_node)
      labelling.sat(parse_tree)
      s0_labelling = labelling.for('s0')
      s1_labelling = labelling.for('s1')
      s2_labelling = labelling.for('s2')
      expect(s0_labelling.labels).to contain_exactly(exists_next_node)
      expect(s1_labelling.labels).to contain_exactly(b_node, exists_next_node)
      expect(s2_labelling.labels).to contain_exactly(b_node)
    end
  end

  context 'when evaluating exists until expressions' do
    it 'labels s0, s1 with E [a U b]' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/simple.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      a_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
      b_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
      exists_until_node = Coeus::ParseTree::ExistsUntil.new(left: a_node, right: b_node)
      parse_tree = Coeus::ParseTree.new(exists_until_node)
      labelling.sat(parse_tree)
      s0_labelling = labelling.for('s0')
      s1_labelling = labelling.for('s1')

      expect(s0_labelling.labels).to contain_exactly(exists_until_node, a_node)
      expect(s1_labelling.labels).to contain_exactly(exists_until_node, b_node)
    end

    it 'labels s0, s1, s2, s3, and s4 of the mutex example for E [!c2 U c1]' do
      # Based on page 226 figure 3.27 "Logic in CS" Mutex example
      yaml = YAML.load_file("#{TestHelper.fixture_path}/exists_until_test.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      c1_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('c1'))
      c2_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('c2'))
      not_node = Coeus::ParseTree::Not.new(child: c2_node)
      exists_until_node = Coeus::ParseTree::ExistsUntil.new(left: not_node, right: c1_node)
      parse_tree = Coeus::ParseTree.new(exists_until_node)
      labelling.sat(parse_tree)
      expectations = {
        's0' => [exists_until_node, not_node],
        's1' => [exists_until_node, not_node],
        's2' => [exists_until_node, c1_node, not_node],
        's3' => [exists_until_node, not_node],
        's4' => [exists_until_node, c1_node, not_node],
        's5' => [not_node],
        's6' => [c2_node],
        's7' => [c2_node],
        's8' => [not_node]
      }
      expectations.each do |state, nodes|
        expect(labelling.for(state).labels).to contain_exactly(*nodes)
      end
      graph = Coeus::Labellings::Graph.from_labelling(labelling)
      graph.draw!
    end

    it 'labels the same as other test with AND T E [!c2 U c1]' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/exists_until_test.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      c1_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('c1'))
      c2_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('c2'))
      not_node = Coeus::ParseTree::Not.new(child: c2_node)
      exists_until_node = Coeus::ParseTree::ExistsUntil.new(left: not_node, right: c1_node)
      true_node = Coeus::ParseTree::True.new
      and_node = Coeus::ParseTree::And.new(left: true_node, right: exists_until_node)
      parse_tree = Coeus::ParseTree.new(and_node)
      labelling.sat(parse_tree)
      expectations = {
        's0' => [exists_until_node, not_node, and_node, true_node],
        's1' => [exists_until_node, not_node, and_node, true_node],
        's2' => [exists_until_node, c1_node, not_node, and_node, true_node],
        's3' => [exists_until_node, not_node, and_node, true_node],
        's4' => [exists_until_node, c1_node, not_node, and_node, true_node],
        's5' => [not_node, true_node],
        's6' => [c2_node, true_node],
        's7' => [c2_node, true_node],
        's8' => [not_node, true_node]
      }
      expectations.each do |state, nodes|
        expect(labelling.for(state).labels).to contain_exactly(*nodes)
      end
    end
  end

  context 'when evaluating universal future expressions' do
    it 'behaves as expected across a tree of state nodes' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/universal_future_test.yaml")
      model = Coeus::Model.from_yaml(yaml)
      labelling = described_class.new(model)
      c1_node = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
      universal_future_node = Coeus::ParseTree::UniversalFuture.new(child: c1_node)
      parse_tree = Coeus::ParseTree.new(universal_future_node)
      labelling.sat(parse_tree)
      expectations = {
        's0' => [],
        's1' => [universal_future_node],
        's2' => [universal_future_node, c1_node],
        's3' => [universal_future_node, c1_node],
        's4' => [],
        's5' => [],
        's6' => [],
        's7' => []
      }
      expectations.each do |state, nodes|
        expect(labelling.for(state).labels).to contain_exactly(*nodes)
      end
    end
  end
end
