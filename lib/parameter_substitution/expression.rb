# frozen_string_literal: true

require 'invoca/utils'

class ParameterSubstitution
  class Expression
    attr_reader :expression_list, :context

    UNKNOWN_PARAM_WARNING_TYPE  = :unknown_param_warning_type
    UNKNOWN_METHOD_WARNING_TYPE = :unknown_method_warning_type

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

    def parameter_and_method_warnings(warning_type = nil)
      if warning_type.nil?
        unknown_messages = unknown_parameter_messages + unknown_method_messages
        unknown_messages.empty? ? nil : unknown_messages.uniq
      elsif warning_type == UNKNOWN_PARAM_WARNING_TYPE
        unknown_parameter_messages.uniq
      elsif warning_type == UNKNOWN_METHOD_WARNING_TYPE
        unknown_method_messages.uniq
      end
    end

    def substitution_parameter_names
      @expression_list.map_compact(&:parameter_name)
    end

    def method_names
      @expression_list.reduce([]) do |all_method_names, expression|
        all_method_names + methods_used_by_expression(expression)
      end
    end

    def methods_used_by_expression(expression)
      if (method_calls = expression.try(:method_calls))
        method_calls.reduce([]) do |all_method_call_names, method_call|
          all_method_call_names + [method_call.name.to_s] + method_call.arguments&.flat_map { |arg| arg.try(:method_names) }.compact # arg.try returns 'nil' when no methods are called; only method names needed
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

    def unknown_method_messages
      unknown_parameter_methods.map_compact do |param, methods|
        method_string = "method#{methods.size > 1 ? 's' : ''}"
        if !(methods.empty? || unknown_parameters.include?(param))
          "Unknown #{method_string} #{@context.formatted_arg_list(methods)} used on parameter '#{param}'"
        end
      end
    end

    def unknown_parameter_messages
      unknown_parameters.map do |param|
        unknown_methods_for_param = unknown_parameter_methods[param]
        method_string = "method#{unknown_methods_for_param.size > 1 ? 's' : ''}"
        unknown_method_message = if unknown_methods_for_param.empty?
                                   ''
                                 else
                                   " and #{method_string} #{@context.formatted_arg_list(unknown_methods_for_param)}"
                                 end
        "Unknown param '#{param}'#{unknown_method_message}"
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

    def unknown_parameter_methods
      @expression_list.select(&:parameter_name).reduce({}) do |hash, expression|
        hash[expression.parameter_name] ||= []
        hash[expression.parameter_name].push(*missing_methods(expression))
        hash
      end
    end

    def missing_methods(expression)
      (methods_used_by_expression(expression) - ParameterSubstitution::Formatters::Manager.all_formats.map { |k, _v| k.to_s })
    end
  end
end
