# frozen_string_literal: true

require 'rly'

module Coeus
  module Language
    # ParserBase declares the parsing rules for evalutating CTL expressions.
    # However, ParserBase is abstract and subclasses must implement
    # parse_binary, parse_unary, parse_until, parse_boolean, and parse_atomic
    class ParserBase < Rly::Yacc
      precedence :left, :AND, :OR
      precedence :left, :IMPLIES, :AU, :EU
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

      # The NOT operator should bind as tightly as possible to the next closest value
      rule 'expression : NOT expression %prec NOT' do |ex, operator, operand|
        ex.value = parse_unary(operator, operand)
      end

      rule 'expression : AF expression
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
