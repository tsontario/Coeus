require 'byebug'
module Coeus
  module Language
    class CTLParse < Rly::Yacc
      # Statement evaluates to a Coeus::ParseTree representing the input expression
      rule 'statement: expression' do |st, e|
        st.value = e.value
      end

      # Binary operators
      rule 'expression : expression AND expression
                       | expression OR expression
                       | expression IMPLIES expression
            ' do |ex, left, op, right|
        ex.value = case op.value
        when "AND"
          ParseTree::And.new(left: left.value, right: right.value)
        when "OR"
          translate_or(left, right)
        when "->"
          translate_implies(left, right)
        else
          raise NotImplementedError
        end
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
        byebug
        ex.value = case operator.value
        when "NOT"
          ParseTree::Not.new(child: operand.value)
        when "AF"
          ParseTree::UniversalFuture(child: operand.value)
        when "EF"
          # TODO
        when "AG"
          translate_universal_global(operand)
        when "EG"
          # TODO
        when "AX"
          translate_universal_next(operand)
        when "EX"
          ParseTree::ExistsUntil(child: operand.value)
        else
          raise NotImplementedError.new("#{operand.value} not translated to adequate set yet")
        end
      end 

      # Until expressions
      rule 'expression : UNIVERSAL LEFT_BRACKET expression UNTIL expression RIGHT_BRACKET
                       | EXISTENTIAL LEFT_BRACKET expression UNTIL expression RIGHT_BRACKET
      ' do | ex, qualifier, _, left, _, right|

      end

      # Atomic values
      rule 'expression : ATOM' do |ex, n|
        ex.value = ParseTree::Atomic.new(n.value)
      end

      # Boolean literals
      rule 'expression : TRUE | FALSE' do |ex, n|
        if n.value == "False"
          ex.value = ParseTree::False.new
        else
          ex.value = ParseTree::Not.new(child: ParseTree::False.new)
        end
      end

      private

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

        outer_not = ParseTree::Not.new(child: and_node)
      end

      def translate_universal_global(child)
        
      end

      def translate_universal_next(child)
        inner_not = ParseTree::Not.new(child: child)
        ex_node = ParseTree::ExistsNext.new(child: inner_not)
        ParseTree::Not.new(child: ex_node)
      end
    end
  end
end
