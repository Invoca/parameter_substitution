# frozen_string_literal: true

class ParameterSubstitution::Formatters::HexToBase64 < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts hex encoded strings to base64 encoding"
  end

  def self.format(value)
    [[value].pack("H*")].pack("m0")
  end
end
