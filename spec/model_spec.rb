# frozen_string_literal: true

describe Coeus::Model do
  context "creating models" do
    it "creates a model from a yaml object" do
      yaml = YAML.load_file("#{TestHelper.fixture_path}/simple.yaml")
      expected_states = yaml['states'].map { |s| TestHelper.state_from_yaml(s) }
      expected_transitions = yaml['transitions'].map { |t| TestHelper.transitions_from_yaml(t) }
      model = Coeus::Model.from_yaml(yaml)
      expect(model.states.sort_by(&:name)).to eq(expected_states.sort_by(&:name))
      expect(model.transitions.sort_by)
    end
  end
end