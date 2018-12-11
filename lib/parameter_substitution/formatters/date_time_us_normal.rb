# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateTimeUsNormal < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "MM/DD/YYYY hh:mm"
  end

  def self.format(value)
    parse_to_time(value)&.strftime("%m/%d/%Y %H:%M").to_s
  end
end
