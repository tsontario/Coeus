# frozen_string_literal: true

module TestHelper
  def self.fixture_path
    File.expand_path('fixtures', __dir__)
  end

  # Helper method to generate State objects from the state stanza of a YAML document
  def self.state_from_yaml(yaml)
    Coeus::State.new(
      name: yaml['name'],
      atoms: yaml['atoms'].map { |a| Coeus::Atom.new(a) },
      initial: yaml['initial']
    )
  end

  # Helper method to generate Transition objects from the state stanza of a YAML document
  def self.transitions_from_yaml(yaml, states)
    Coeus::Transition.new(
      from: states.find { |s| s.name == yaml['from'] },
      to: states.select { |s| yaml['to'].include?(s.name) }
    )
  end
end
