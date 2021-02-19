# frozen_string_literal: true

require_relative './parser_base'

module Coeus
  module Language
    # TranslationParser provides the parsing logic to translate CTL expressions into a Coeus::ParseTree
    # with the additional behaviour of converting expressions into equivalent forms that use an adequate set
    class TranslationParser < ParserBase
      # We need to explicitly assign the rules to this class, Rly won't look up the ancestor chain, unfortunately
      self.rules = ParserBase.rules

      private

      def parse_unary(operator, operand)
        case operator.value
        when 'NOT'
          ParseTree::Not.new(child: operand.value)
        when 'AF'
          ParseTree::UniversalFuture(child: operand.value)
        when 'EF'
          # TODO
        when 'AG'
          # STILL TODO
          translate_universal_global(operand)
        when 'EG'
          translate_exists_global(operand)
        when 'AX'
          translate_universal_next(operand)
        when 'EX'
          ParseTree::ExistsUntil(child: operand.value)
        else
          raise NotImplementedError, "#{operand.value} not translated to adequate set yet"
        end
      end

      def parse_binary(left, operator, right)
        case operator.value
        when 'AND'
          ParseTree::And.new(left: left.value, right: right.value)
        when 'OR'
          translate_or(left, right)
        when '->'
          translate_implies(left, right)
        else
          raise NotImplementedError
        end
      end

      def parse_boolean(bool)
        if bool.value == 'False'
          ParseTree::False.new
        else
          ParseTree::Not.new(child: ParseTree::False.new)
        end
      end

      def parse_atomic(atom)
        ParseTree::Atomic.new(atom.value)
      end

      # P v Q == ~(~P ^ ~Q)
      def translate_or(left, right)
        right_node = ParseTree::Not.new(child: right)
        left_node = ParseTree::Not.new(child: left)
        or_node = ParseTree::Or.new(left: left_node, right: right_node)
        ParseTree::Not.new(child: or_node)
      end

      # P -> Q == ~(P ^ ~Q)
      def translate_implies(left, right)
        right_node = ParseTree::Not.new(child: right.value)
        and_node = ParseTree::And.new(left: left.value, right: right_node)
        ParseTree::Not.new(child: and_node)
      end

      # EG(~P) == ~AF(P)
      def translate_exists_global(child)
        inner_not_node = ParseTree::Not.new(child: child)
        af_node = ParseTree::UniversalFuture.new(child: inner_not_node)
        ParseTree::Not.new(child: af_node)
      end

      def translate_universal_global(child)
        # TODO
      end

      def translate_universal_next(child)
        inner_not = ParseTree::Not.new(child: child)
        ex_node = ParseTree::ExistsNext.new(child: inner_not)
        ParseTree::Not.new(child: ex_node)
      end
    end
  end
end
