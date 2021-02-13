# frozen_string_literal: true

describe Coeus::Labelling do
  yaml = YAML.load_file("#{TestHelper.fixture_path}/simple.yaml")
  model = Coeus::Model.from_yaml(yaml)
  labelling = Coeus::Labelling.new(model)

  it 'should label only s0 with state a' do
    atomic_expression = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('a'))
    parse_tree = Coeus::ParseTree.new(atomic_expression)
    labelling.sat(parse_tree)
    s0_labelling = labelling.for('s0')
    s1_labelling = labelling.for('s1')
    expect(s0_labelling.labels).to include(atomic_expression)
    expect(s1_labelling.labels).to be_empty
  end

  it 'should label only s1 with state b' do
    atomic_expression = Coeus::ParseTree::Atomic.new(Coeus::Atom.new('b'))
    parse_tree = Coeus::ParseTree.new(atomic_expression)
    labelling.sat(parse_tree)
    s0_labelling = labelling.for('s0')
    s1_labelling = labelling.for('s1')
    expect(s0_labelling.labels).to be_empty
    expect(s1_labelling.labels).to include(atomic_expression)
  end
end
