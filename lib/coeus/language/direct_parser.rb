# frozen_string_literal: true

require_relative './parser_base'

module Coeus
  module Language
    # This is a bit of a dirty trick, but we are dynamically defining node names here to avoid
    # hardcoding them in ParseTree (since we don't need to define #sat for them)
    module FakeNode
      const_set('True', Class.new(ParseTree::LeafNode))

      %w[Or Implies].each do |class_name|
        klass = Class.new(ParseTree::BinaryNode)
        const_set(class_name, klass)
      end

      %w[ExistsFuture UniversalGlobal ExistsGlobal UniversalNext].each do |class_name|
        klass = Class.new(ParseTree::UnaryNode)
        const_set(class_name, klass)
      end
    end

    # DirectParser provides the parsing logic to translate CTL expressions into a Coeus::ParseTree
    # It is used mainly for evaluating and testing the precedence rules of the CTL parser
    class DirectParser < ParserBase
      self.rules = ParserBase.rules
      self.prec_rules = ParserBase.prec_rules

      def parse_binary(left, operator, right)
        case operator.value
        when 'AND'
          ParseTree::And.new(left: left.value, right: right.value)
        when 'OR'
          FakeNode::Or.new(left: left.value, right: right.value)
        when '->'
          FakeNode::Implies.new(left: left.value, right: right.value)
        else
          raise NotImplementedError
        end
      end

      def parse_unary(operator, operand)
        case operator.value
        when 'NOT'
          ParseTree::Not.new(child: operand.value)
        when 'AF'
          ParseTree::UniversalFuture(child: operand.value)
        when 'EF'
          FakeNode::ExistsFuture.new(child: operand.value)
        when 'AG'
          FakeNode::UniversalGlobal.new(child: operand.value)
        when 'EG'
          FakeNode::ExistsGlobal.new(child: operand.value)
        when 'AX'
          FakeNode::UniversalNext.new(child: operand.value)
        when 'EX'
          ParseTree::ExistsUntil(child: operand.value)
        else
          raise NotImplementedError, "#{operand.value} not translated to adequate set yet"
        end
      end

      def parse_boolean(bool)
        if bool.value == 'False'
          ParseTree::False.new
        else
          FakeNode::True.new
        end
      end

      def parse_atomic(atom)
        ParseTree::Atomic.new(atom.value)
      end
    end
  end
end
