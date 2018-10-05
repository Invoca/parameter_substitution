# frozen_string_literal: true

require 'hobo_support/enumerable'

class ParameterSubstitution
  class Context
    attr_reader :input, :mapping, :required_parameters, :parameter_start, :parameter_end,
                :destination_encoding, :allow_unknown_replacement_parameters, :allow_nil,
                :allow_unmatched_parameter_end

    def initialize(
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

      @input = input
      @mapping = mapping
      @required_parameters = required_parameters
      @parameter_start = parameter_start
      @parameter_end = parameter_end
      @destination_encoding = destination_encoding
      @allow_unknown_replacement_parameters = allow_unknown_replacement_parameters
      @allow_nil = allow_nil
      @allow_unmatched_parameter_end = allow_unmatched_parameter_end
    end

    def allow_unknown_params?(inside_quotes)
      allow_unknown_replacement_parameters || (destination_encoding == :json && inside_quotes)
    end

    def mapping_has_key?(key)
      downcased_mapping.key?(key.downcase)
    end

    def mapped_value(key)
      downcased_mapping[key.downcase]
    end

    def mapping_keys
      mapping.keys
    end

    def formatted_arg_list(arg_list)
      arg_list.sort.map { |arg| "'#{arg}'" }.join(", ")
    end

    def duplicate_raw
      ParameterSubstitution::Context.new(
        input: @input,
        mapping: @mapping,
        required_parameters: @required_parameters,
        parameter_start: @parameter_start,
        parameter_end: @parameter_end,
        destination_encoding: :raw,
        allow_unknown_replacement_parameters: @allow_unknown_replacement_parameters,
        allow_nil: @allow_nil,
        allow_unmatched_parameter_end: @allow_unmatched_parameter_end
      )
    end

    private

    def downcased_mapping
      @downcase_mapping ||= mapping.build_hash { |k, v| [k.downcase, v] }
    end
  end
end
