# frozen_string_literal: true

require 'active_support/all'

require_relative 'coeus/model'
require_relative 'coeus/labelling'
require_relative 'coeus/parse_tree'

# Entrypoint for library
module Coeus
  class Error < StandardError; end
end