# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateTimeIso8601 < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "iso8601 - 2017-04-11T15:55:10+00:00"
  end

  def self.format(value)
    parse_to_time(value)&.iso8601
  end
end
