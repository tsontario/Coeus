# frozen_string_literal: true

describe Coeus::Model do
  context 'when creating models' do
    it 'creates a model from a yaml object' do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/simple.yaml")
      expected_states = yaml['states'].map { |s| TestHelper.state_from_yaml(s) }
      expected_transitions = yaml['transitions'].map { |t| TestHelper.transitions_from_yaml(t, expected_states) }
      model = described_class.from_yaml(yaml)
      expect(model.states).to eq(expected_states)
      expect(model.transitions).to eq(expected_transitions)
    end
  end
end
