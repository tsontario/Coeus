# frozen_string_literal: true

# Code inspired by https://github.com/tenderlove/rexical/wiki/Overview-of-rexical-part-2
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |c|
  options = ['--color']
  options += ['--format', 'documentation']
  c.rspec_opts = options
end

desc 'Generate Lexer'
task :lexer do
  path = File.expand_path(File.join('..', 'lib', 'coeus', 'language'), __FILE__)
  `bundle exec rex #{File.join(path, 'ctl.rex')} -o #{File.join(path, 'lexer.rb')}`
end
