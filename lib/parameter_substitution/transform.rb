# frozen_string_literal: true

require 'parslet'
#
# The transform takes the output from the parser and constructs an Abstract Syntax Tree
# from the result.  In this case, the output is a list of either TextExpression or SubstitutionExpressions.
#
# See the parslet documentation for more detail.
#

class ParameterSubstitution
  class Transform < Parslet::Transform
    def initialize(context)
      @context = context
      super
      define_instance_rules
    end

    #
    # Argument lists
    #
    rule float_arg: simple(:float) do
      float.to_f
    end

    rule int_arg: simple(:int) do
      int.to_i
    end

    rule string_arg: simple(:string) do
      # Strip all leading slashes.
      ParameterSubstitution::Transform.unescape(string)
    end

    rule string_arg: sequence(:string) do
      ""
    end

    rule nil_arg: simple(:_) do
      nil
    end

    rule arg_list: sequence(:parameters) do
      parameters
    end

    rule arg_list: simple(:parameter) do
      [parameter]
    end

    #
    # Method Call
    #
    rule(method_call: simple(:method_call), arg_list: sequence(:arg_list)) do
      MethodCallExpression.new(method_call, arg_list)
    end

    rule(method_call: simple(:method_calls), arg_list: simple(:arg)) do
      MethodCallExpression.new(method_call, [arg])
    end

    rule method_call: simple(:method_call) do
      MethodCallExpression.new(method_call, [])
    end

    #
    # The overall expression
    #
    rule text: simple(:text) do
      TextExpression.new(text.to_s)
    end

    def self.unescape(string)
      string.to_s.gsub(/\\(.)/) { |v| v[1] }
    end

    private

    def define_instance_rules
      # This rule must be defined on the instance so that it can access attributes on the instance.
      # The definition also takes a parameter to the block so that the block is bound to the instance
      rule expression: sequence(:parameters) do |dictionary|
        ParameterSubstitution::Expression.new(dictionary[:parameters], @context)
      end

      rule raw_expression: sequence(:parameters) do |dictionary|
        ParameterSubstitution::Expression.new(dictionary[:parameters], @context.duplicate_raw)
      end

      rule parameter_name: simple(:parameter_name),  method_calls: sequence(:method_calls) do |dictionary|
        SubstitutionExpression.new(
          ParameterSubstitution::Transform.unescape(dictionary[:parameter_name].to_s),
          dictionary[:method_calls],
          @context
        )
      end
    end
  end
end
