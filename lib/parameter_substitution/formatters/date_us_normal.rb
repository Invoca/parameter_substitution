# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateUsNormal < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "MM/DD/YYYY"
  end

  def self.format(value)
    parse_to_time(value)&.strftime("%m/%d/%Y").to_s
  end
end
