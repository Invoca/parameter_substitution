# frozen_string_literal: true

require_relative 'test_formatter_base'

class Downcase < TestFormatterBase
  def self.description
    "Converts to string and downcases the values, preserves nil"
  end

  def self.format(value)
    value && value.to_s.downcase
  end
end
