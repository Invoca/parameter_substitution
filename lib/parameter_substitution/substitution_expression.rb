# frozen_string_literal: true

require 'hobo_support/array'

class ParameterSubstitution
  class SubstitutionExpression
    attr_accessor :parameter_name, :method_calls, :context

    def initialize(parameter_name, method_calls, context)
      @context = context
      @parameter_name, @method_calls = fixup_name_and_method_calls(parameter_name, method_calls)
    end

    def validate(_inside_quotes)
      # TODO: - Chase down callers who pass allow_nil = false.  Can we get rid of them?
      if !@context.allow_nil && @context.mapping_has_key?(@parameter_name) && @context.mapped_value(@parameter_name).nil?
        raise ParameterSubstitution::ParseError, "Replacement parameter '#{@parameter_name}' is nil"
      end

      method_calls.each(&:validate)
    end

    def unknown_parameters(inside_quotes)
      if !@context.mapping_has_key?(@parameter_name) && !(@context.destination_encoding == :json && inside_quotes)
        @parameter_name
      end
    end

    def evaluate(inside_quotes, only_expression: false)
      if @context.mapping_has_key?(@parameter_name)
        formatted_value = format(@context.mapped_value(@parameter_name), inside_quotes)
        if @context.destination_encoding == :raw && formatted_value.nil?
          only_expression ? '' : "#{@context.parameter_start}#{@parameter_name}#{@context.parameter_end}"
        else
          formatted_value
        end
      else
        if @context.destination_encoding == :raw && only_expression
          ''
        else
          "#{@context.parameter_start}#{@parameter_name}#{@context.parameter_end}"
        end
      end
    end

    def ends_inside_quotes(started_inside_quotes:)
      started_inside_quotes
    end

    private

    def fixup_name_and_method_calls(parameter_name, method_calls)
      if args = try_parameter_name(parameter_name, method_calls)
        args
      else
        [parameter_name, method_calls]
      end
    end

    def try_parameter_name(parameter_name, method_calls)
      if @context.mapping_has_key?(parameter_name)
        [parameter_name, method_calls]
      elsif !method_calls.empty? && method_calls.first.arguments.empty?
        first_method = method_calls.first
        remainder = method_calls[1..-1]
        try_parameter_name(parameter_name + "." + first_method.name, remainder)
      end
    end

    def format(lookup_value, inside_quotes)
      raw_value = @method_calls.reduce(lookup_value) { |previous_value, method| method.call_method(previous_value) }
      Encoder.encode(raw_value, @context.destination_encoding, source_encoding, @parameter_name, inside_quotes)
    end

    def source_encoding
      @method_calls.last&.encoding || :text
    end
  end
end
