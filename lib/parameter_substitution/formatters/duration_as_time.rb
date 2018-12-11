# frozen_string_literal: true

class ParameterSubstitution::Formatters::DurationAsTime < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts a duration in seconds into hh:mm:ss"
  end

  def self.format(duration)
    Time.at(parse_duration(duration)).utc.strftime("%H:%M:%S")
  end
end
