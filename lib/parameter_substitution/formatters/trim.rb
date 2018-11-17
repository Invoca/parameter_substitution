# frozen_string_literal: true

class ParameterSubstitution::Formatters::Trim < ParameterSubstitution::Formatters::Base
  def self.description
    "Returns the input as a string with leading and trailing whitespace removed."
  end

  def self.format(value)
    value&.to_s&.strip
  end
end
