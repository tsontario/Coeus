# frozen_string_literal: true

require 'rly'

module Coeus
  module Language
    # CTLParse provides the parsing logic to translate CTL expressions into a Coeus::ParseTree
    class ParserBase < Rly::Yacc
      # Precedence statements (lower in the list == higher precedence)
      precedence :left, :IMPLIES, :AU, :EU
      precedence :left, :AND, :OR
      precedence :right, :NOT, :AG, :EG, :AF, :EF, :AX, :EX

      # Results are wrapped in a ParseTree object
      rule 'statement: expression' do |st, e|
        st.value = ParseTree.new(e.value)
      end

      # Parentheses
      rule 'expression : LEFT_PAREN expression RIGHT_PAREN' do |ex, _, expression, _|
        ex.value = expression.value
      end

      # Binary operators
      rule 'expression : expression AND expression
                       | expression OR expression
                       | expression IMPLIES expression
            ' do |ex, left, operator, right|
        ex.value = parse_binary(left, operator, right)
      end

      # Unary operators
      rule 'expression : NOT expression
                       | AF expression
                       | EF expression
                       | AG expression
                       | EG expression
                       | AX expression
                       | EX expression
      ' do |ex, operator, operand|
        ex.value = parse_unary(operator, operand)
      end

      # Until expressions
      rule 'expression : UNIVERSAL LEFT_BRACKET expression UNTIL expression RIGHT_BRACKET
                       | EXISTENTIAL LEFT_BRACKET expression UNTIL expression RIGHT_BRACKET
      ' do |ex, qualifier, _, left, _, right|
        ex.value = parse_until(qualifier, left, right)
      end

      # Atomic values
      rule 'expression : ATOM' do |ex, n|
        ex.value = parse_atomic(n)
      end

      # Boolean literals
      rule 'expression : TRUE | FALSE' do |ex, n|
        ex.value = parse_boolean(n)
      end
    end
  end
end
