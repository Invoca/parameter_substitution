# frozen_string_literal: true

class ParameterSubstitution::Formatters::SplitAndFind < ParameterSubstitution::Formatters::Base
  def self.description
    "Takes delimiter and index as arguments. Splits the input on delimiters and returns the indexed element. Preserves nil."
  end

  def self.has_parameters?
    true
  end

  def initialize(delimiter, index)
    @delimiter = delimiter
    @index = index
  end

  def format(value)
    value && value.to_s.split(@delimiter)[@index]
  end
end
