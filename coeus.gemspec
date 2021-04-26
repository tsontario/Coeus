# frozen_string_literal: true

require_relative 'lib/coeus/version'

Gem::Specification.new do |spec|
  spec.name          = 'coeus'
  spec.version       = Coeus::VERSION
  spec.authors       = ['Timothy Smith']
  spec.email         = ['tsontario@gmail.com']
  spec.license       = 'MIT'

  spec.summary       = ' CTL model checker, including expression parser '
  spec.description   = ' CTL model checker, expression parser.'
  spec.homepage      = 'https://github.com/tsontario/coeus'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency('activesupport', '~> 6.1')
  spec.add_dependency('rake', '~> 13.0')
  spec.add_dependency('rly', '~> 0.2.3')

  spec.add_development_dependency('rspec', '~> 3.10')
  spec.add_development_dependency('rubocop', '~> 1.12')
  spec.add_development_dependency('rubocop-rspec', '~> 2.0')
end
