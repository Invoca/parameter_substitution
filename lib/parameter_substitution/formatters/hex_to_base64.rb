# frozen_string_literal: true

class ParameterSubstitution::Formatters::HexToBase64 < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts hex encoded strings to base64 encoding"
  end

  def self.format(value)
    raise ArgumentError, "Bad non-hex input to hex_to_base64" if value !~ /^\h+$/

    [[value].pack("H*")].pack("m0")
  end
end
