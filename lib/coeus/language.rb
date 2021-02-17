# frozen_string_literal: true

require_relative 'parse_tree'
Dir.glob(File.expand_path('language/*.rb', __dir__)).sort.each do |file|
  require file
end

module Coeus
  # The Language module contains parser and lexer implementations
  module Language
    class << self
      # Takes as input a string expression representing a CTL expression and returns
      # a ParseTree instance representing it. The expression is represented using
      # an adequate set, so internal representation may differ from the exact input
      def from_expression(expression)
        parser = Language.ctl_parser.parse(expression)
        

      end

      def ctl_parser
        CTLParse.new(CTLLex.new)
      end
    end
  end
end
