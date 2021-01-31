module TestHelper
  def self.fixture_path
    File.expand_path('../fixtures', __FILE__)
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
  def transitions_from_yaml(yaml)
    Transition.new(from: yaml['from'], to: yaml['to'])
  end
end
