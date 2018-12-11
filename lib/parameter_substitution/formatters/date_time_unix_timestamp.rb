# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateTimeUnixTimestamp < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "unix timestamp"
  end

  def self.format(value)
    parse_to_time(value)&.to_i
  end
end
