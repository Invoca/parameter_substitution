# frozen_string_literal: true

class ParameterSubstitution::Formatters::StringToBase64 < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts strings to base64 encoding"
  end

  def self.format(value)
    return nil if value.nil?

    [value].pack("m0")
  end
end
