# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateTimeIso8601Zulu < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "iso8601 - 2017-04-11T07:00Z"
  end

  def self.format(value)
    parse_to_time(value)&.strftime("%Y-%m-%dT%TZ")
  end
end
