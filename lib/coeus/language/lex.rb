# frozen_string_literal: true

require 'rly'

module Coeus
  module Language
    # CTLLex defines the tokenization for a CTL expression
    class CTLLex < Rly::Lex
      # Ignore whitespace
      ignore " \t\n"

      # State operators
      token :OR, /OR/
      token :AND, /AND/
      token :NOT, /NOT/
      token :IMPLIES, /->/

      # Path descriptors
      token :AF, /AF/
      token :EF, /EF/
      token :AG, /AG/
      token :EG, /EG/
      token :AX, /AX/
      token :EX, /EX/

      token :UNIVERSAL, /A/
      token :EXISTENTIAL, /E/
      token :UNTIL, /U/

      token :LEFT_BRACKET, /\[/
      token :RIGHT_BRACKET, /\]/

      token :LEFT_PAREN, /\(/
      token :RIGHT_PAREN, /\)/

      # Boolean literals
      token :TRUE, /TRUE/
      token :FALSE, /FALSE/

      # E.g. 'p', 't1', 'c2' 'ttt', 't1s'...
      token :ATOM, /[a-zA-Z]\w*/

      on_error do |t|
        puts "Illegal character #{t.value}"
        t.lexer.pos += 1
        nil
      end
    end
  end
end
