# frozen_string_literal: true

class ParameterSubstitution::Formatters::BlankIfNil < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts nil values to empty strings: ''"
  end

  def self.format(value)
    value.nil? ? "" : value
  end
end
