# frozen_string_literal: true

class ParameterSubstitution::Formatters::ToF < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts a string to a double-precision floating point number"
  end

  def self.format(value)
    return nil if value.nil? || value.to_s.strip.empty?
    return nil unless value.match?(/^\d+\.?\d*$/)

    value.to_f.round(2)
  end
end