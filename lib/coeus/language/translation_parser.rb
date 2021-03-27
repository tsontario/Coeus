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
        when 'EF'
          translate_exists_future(operand.value)
        when 'EG'
          translate_exists_global(operand.value)
        when 'EX'
          ParseTree::ExistsNext.new(child: operand.value)
        when 'AF'
          ParseTree::UniversalFuture.new(child: operand.value)
        when 'AG'
          translate_universal_global(operand.value)
        when 'AX'
          translate_universal_next(operand.value)
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

      def parse_until()
        #TODO args + body
      end

      # P v Q == ~(~P ^ ~Q)
      def translate_or(left, right)
        left_node = ParseTree::Not.new(child: left)
        right_node = ParseTree::Not.new(child: right)
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

      # EF(phi) = E(T u phi)
      def translate_exists_future(child)
        left_node = ParseTree::Not.new(child: ParseTree::False.new)
        right_node = child
        ParseTree::ExistsUntil.new(left: left_node, right: right_node)
      end

      # AG = NOT(EF(!phi))
      def translate_universal_global(child)
        ParseTree::Not.new(child: translate_exists_future(ParseTree::Not.new(child: child)))
      end

      def translate_universal_next(child)
        inner_not = ParseTree::Not.new(child: child)
        ex_node = ParseTree::ExistsNext.new(child: inner_not)
        ParseTree::Not.new(child: ex_node)
      end
    end
  end
end
