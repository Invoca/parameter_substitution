# frozen_string_literal: true

# See lib/parameter_substitution/readme.md

require 'active_support/all'
require "parameter_substitution/context"
require "parameter_substitution/parse_error"
require "parameter_substitution/parser"
require "parameter_substitution/transform"
require "parameter_substitution/encoder"
require "parameter_substitution/method_call_expression"
require "parameter_substitution/substitution_expression"
require "parameter_substitution/text_expression"
require "parameter_substitution/expression"
require "parameter_substitution/configuration"
require "parameter_substitution/formatters/base"
require "parameter_substitution/formatters/date_time_format"
Dir[File.dirname(__FILE__) + '/parameter_substitution/formatters/*.rb'].each do |file|
  require file
end

class ParameterSubstitution
  class SubstitutionError < StandardError; end

  cattr_accessor :config

  class << self
    def evaluate(
      input:,
      mapping:,
      required_parameters: [],
      parameter_start: "<",
      parameter_end: ">",
      destination_encoding: :text,
      allow_unknown_replacement_parameters: false,
      allow_nil: false,
      allow_unmatched_parameter_end: false
    )
      context = ParameterSubstitution::Context.new(
        input: input,
        mapping: mapping,
        required_parameters: required_parameters,
        parameter_start: parameter_start,
        parameter_end: parameter_end,
        destination_encoding: destination_encoding,
        allow_unknown_replacement_parameters: allow_unknown_replacement_parameters,
        allow_nil: allow_nil,
        allow_unmatched_parameter_end: allow_unmatched_parameter_end
      )

      expression = parse_expression(context)
      expression.validate
      [expression.evaluate, expression.warnings, expression.parameter_and_method_warnings]
    rescue ParameterSubstitution::ParseError => ex
      [context.input, ex.message, expression&.parameter_and_method_warnings]
    rescue => ex
      raise SubstitutionError, "Error occurred while parameter substitution: #{ex.message}"
    end

    def configure
      config = ParameterSubstitution::Configuration.new
      yield(config)
      ParameterSubstitution.config = config
    end

    def find_tokens(string_with_tokens, mapping: {})
      parse_expression(context_from_string(string_with_tokens, mapping)).substitution_parameter_names
    end

    def find_formatters(string_with_tokens, mapping: {})
      parse_expression(context_from_string(string_with_tokens, mapping)).method_names
    end

    def find_warnings(string_with_tokens, mapping: {})
      parse_expression(context_from_string(string_with_tokens, mapping)).parameter_and_method_warnings || []
    end

    private

    def context_from_string(string_with_tokens, mapping)
      ParameterSubstitution::Context.new(input: string_with_tokens, mapping: mapping)
    end

    def parse_expression(context)
      cst = ParameterSubstitution::Parser.new(
        parameter_start: context.parameter_start,
        parameter_end: context.parameter_end,
        allow_unmatched_parameter_end: context.allow_unmatched_parameter_end
      ).parse(context.input)
      ParameterSubstitution::Transform.new(context).apply(cst)
    rescue Parslet::ParseFailed => ex
      if ex.message =~ /Extra input after last repetition at/
        case context.input[ex.parse_failure_cause.pos.charpos]
        when context.parameter_start
          raise ParameterSubstitution::ParseError, "Missing '#{context.parameter_end}' after '#{context.parameter_start}'"
        when context.parameter_end
          raise ParameterSubstitution::ParseError, "Missing '#{context.parameter_start}' before '#{context.parameter_end}'"
        else
          raise
        end
      else
        raise
      end
    end
  end
end
