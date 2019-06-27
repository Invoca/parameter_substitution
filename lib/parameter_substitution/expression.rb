# frozen_string_literal: true

require 'invoca/utils'

class ParameterSubstitution
  class Expression
    attr_reader :expression_list, :context

    def initialize(expression_list, context)
      @expression_list = expression_list
      @context = context
    end

    def validate
      validate_required_parameters
      validate_unknown_parameters
      validate_expressions
    end

    def evaluate
      if context.destination_encoding == :raw && @expression_list.size == 1
        # When using the destination encoding of raw, the output should preserve the type from the mapping if the substitution
        # is the full expression.  So the input of '<id>' with the mapping { 'id' => 1 } should return 1 and not "1".
        @expression_list.first.evaluate(:OutsideString, only_expression: true)
      else
        map_expressions_with_quote_tracking do |expression, inside_quotes|
          expression.evaluate(inside_quotes).to_s
        end.join("")
      end
    end

    def warnings
      unknown_parameters_message
    end

    def substitution_parameter_names
      @expression_list.map_compact(&:parameter_name)
    end

    def method_names
      @expression_list.reduce([]) do |all_method_names, expression|
        all_method_names + name_from_method_calls(expression)
      end
    end

    def name_from_method_calls(expression)
      if (method_calls = expression.try(:method_calls))
        method_calls.reduce([]) do |all_method_call_names, method_call|
          all_method_call_names + [method_call.name.to_s] + method_call.arguments&.flat_map { |arg| arg.try(:method_names) }
        end
      else
        []
      end
    end

    private

    def validate_required_parameters
      matched_parameters = substitution_parameter_names.uniq
      required_parameters = @context.required_parameters
      if !required_parameters.empty? && (missing_fields = required_parameters.reject { |rt| rt.in?(matched_parameters) }).any?
        raise ParameterSubstitution::ParseError, "The following field#{missing_fields.size > 1 ? 's' : ''} must be included: #{@context.formatted_arg_list(missing_fields)}"
      end
    end

    def validate_unknown_parameters
      unless @context.allow_unknown_replacement_parameters
        if (message = unknown_parameters_message)
          raise ParameterSubstitution::ParseError, message
        end
      end
    end

    def validate_expressions
      map_expressions_with_quote_tracking do |expression, inside_quotes|
        expression.validate(inside_quotes)
      end
    end

    def unknown_parameters_message
      unless unknown_parameters.empty?
        "Unknown replacement parameter#{unknown_parameters.size > 1 ? 's' : ''} #{@context.formatted_arg_list(unknown_parameters)}"
      end
    end

    def map_expressions_with_quote_tracking
      inside_quotes = false
      @expression_list.map do |expression|
        result = yield expression, inside_quotes
        inside_quotes = expression.ends_inside_quotes(started_inside_quotes: inside_quotes)
        result
      end
    end

    def unknown_parameters
      @unknown_parameters ||=
        map_expressions_with_quote_tracking do |expression, inside_quotes|
          expression.unknown_parameters(inside_quotes)
        end.compact
    end
  end
end
