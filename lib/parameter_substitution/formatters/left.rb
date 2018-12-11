# frozen_string_literal: true

class ParameterSubstitution::Formatters::Left < ParameterSubstitution::Formatters::Base
  def self.description
    "Takes a single n argument. Returns the left most n characters from the input."
  end

  def self.has_parameters?
    true
  end

  def initialize(character_count)
    @character_count = character_count
  end

  def format(value)
    value.to_s[0, @character_count]
  end
end
