# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateTimeUsSeconds < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "MM/DD/YYYY hh:mm:ss"
  end

  def self.format(value)
    parse_to_time(value)&.strftime("%m/%d/%Y %H:%M:%S").to_s
  end
end
