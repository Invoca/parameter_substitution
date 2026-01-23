# frozen_string_literal: true

class ParameterSubstitution::Formatters::ToF < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts a string to a double-precision floating point number"
  end

  def self.format(value)
    Float(value).round(2) rescue nil
  end
end