# frozen_string_literal: true

class ParameterSubstitution::Formatters::DurationGroupedByDescription < ParameterSubstitution::Formatters::Base
  DURATION_DESCRIPTIONS = [
    [30.seconds, "<30sec"],
    [60.seconds, "30-60sec"],
    [5.minutes, "1-5min"],
    [10.minutes, "5-10min"],
    [20.minutes, "10-20min"],
    [30.minutes, "20-30min"],
    [60.minutes, "30-60min"],
    [nil,        ">60min"]
  ].freeze

  def self.description
    "Converts a duration in seconds into one of the following: #{DURATION_DESCRIPTIONS.map(&:last).join(',')}"
  end

  def self.format(duration)
    fixed_duration = parse_duration(duration)
    DURATION_DESCRIPTIONS.find { |max_duration, _description| !max_duration || fixed_duration.to_i < max_duration }.last
  end
end
