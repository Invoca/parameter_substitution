# frozen_string_literal: true

require_relative 'test_formatter_base'

class IfNil < TestFormatterBase
  def self.has_parameters?
    true
  end

  def self.description
    "Takes one new_value parameter.  If the input is nil the input is replaced with new_value"
  end

  def initialize(new_value)
    @new_value = new_value
  end

  def format(value)
    value.nil? ? @new_value : value
  end
end
