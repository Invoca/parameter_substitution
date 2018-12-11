# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateTimeUtcYearFirstDashesSeconds < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "2017-04-11 15:55:10 (UTC)"
  end

  def self.format(value)
    parse_to_time(value)&.utc&.strftime('%Y-%m-%d %H:%M:%S')
  end
end
