# frozen_string_literal: true

source 'https://rubygems.org'

ruby '>= 2.7.0'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'activesupport', '~> 6.1'

gem 'rspec', '~> 3.12'

gem 'rubocop', '~> 1.12'

gem 'byebug', '~> 11.1'

gem 'rubocop-rspec', '~> 2.0', require: false

gem 'rly', '~> 0.2.3'

gem 'rake', '~> 13.0'

gem 'rgl', '~> 0.5.7'
group :ci_skip do
  # We don't need graph drawing code in CI (in fact, it can't load the TK native libraries anyway)
  gem 'graphviz', '~> 1.2'
  gem 'tk', '~> 0.4.0'
end
