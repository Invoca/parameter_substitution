# frozen_string_literal: true

class ParameterSubstitution::Formatters::SplitBeforeColon < ParameterSubstitution::Formatters::Base
  def self.description
    "Returns the portion of a string before the first colon, or the full string if there is no colon."
  end

  def self.format(value)
    value && value.to_s.split(':')[0]
  end
end
