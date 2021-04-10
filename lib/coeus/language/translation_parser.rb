# frozen_string_literal: true

require_relative './parser_base'

module Coeus
  module Language
    # TranslationParser provides the parsing logic to translate CTL expressions into a Coeus::ParseTree
    # with the additional behaviour of converting expressions into equivalent forms that use an adequate set
    class TranslationParser < ParserBase
      # We need to explicitly assign the rules and precedence rules to this class,
      # Rly won't look up the ancestor chain, unfortunately
      self.rules = ParserBase.rules
      self.prec_rules = ParserBase.prec_rules

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
          raise NotImplementedError
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
        if bool.value.match(/false/i)
          ParseTree::False.new
        else
          ParseTree::Not.new(child: ParseTree::False.new)
        end
      end

      def parse_atomic(atom)
        ParseTree::Atomic.new(Coeus::Atom.new(atom.value))
      end

      def parse_until(qualifier, left, right)
        case qualifier.value
        when 'E'
          ParseTree::ExistsUntil.new(left: left.value, right: right.value)
        when 'A'
          translate_universal_until(left, right)
        else
          raise NotImplementedError
        end
      end

      # P v Q == ~(~P ^ ~Q)
      def translate_or(left, right)
        left_node = ParseTree::Not.new(child: left.value)
        right_node = ParseTree::Not.new(child: right.value)
        and_node = ParseTree::And.new(left: left_node, right: right_node)
        ParseTree::Not.new(child: and_node)
      end

      # P -> Q == ~(P ^ ~Q)
      def translate_implies(left, right)
        right_node = ParseTree::Not.new(child: right.value)
        and_node = ParseTree::And.new(left: left.value, right: right_node)
        ParseTree::Not.new(child: and_node)
      end

      # EG(~P) == ~AF(P)
      def translate_exists_global(child)
        inner_not_node = ParseTree::Not.new(child: as_node(child))
        af_node = ParseTree::UniversalFuture.new(child: inner_not_node)
        ParseTree::Not.new(child: af_node)
      end

      # EF(phi) = E(T u phi)
      def translate_exists_future(child)
        left_node = ParseTree::Not.new(child: ParseTree::False.new)
        right_node = as_node(child)
        ParseTree::ExistsUntil.new(left: left_node, right: right_node)
      end

      # AG = ~(EF(~phi))
      def translate_universal_global(child)
        ParseTree::Not.new(
          child: ParseTree::ExistsUntil.new(
            left: ParseTree::Not.new(child: ParseTree::False.new),
            right: ParseTree::Not.new(child: as_node(child))
          )
        )
      end

      # AX = ~EX(~phi)
      def translate_universal_next(child)
        inner_not = ParseTree::Not.new(child: child)
        ex_node = ParseTree::ExistsNext.new(child: inner_not)
        ParseTree::Not.new(child: ex_node)
      end

      # A[a U b] = (~E[~b U (~a AND ~b)] AND AF(b))
      def translate_universal_until(left, right)
        ParseTree::And.new(
          left: ParseTree::Not.new(
            child: ParseTree::ExistsUntil.new(
              left: ParseTree::Not.new(
                child: as_node(right)
              ),
              right: ParseTree::And.new(
                left: ParseTree::Not.new(
                  child: as_node(left)
                ),
                right: ParseTree::Not.new(
                  child: as_node(right)
                )
              )
            )
          ),
          right: ParseTree::UniversalFuture.new(
            child: as_node(right)
          )
        )
      end

      # prefer this to directly using #value, since we may forward racc expressions between translation methods we
      # can't be certain if the argument will be in the form of a ParseTree::Node or still as a parser object
      def as_node(symbol_or_node)
        symbol_or_node.is_a?(ParseTree::Node) ? symbol_or_node : symbol_or_node.value
      end
    end
  end
end
