# frozen_string_literal: true

class ParameterSubstitution::Formatters::Right < ParameterSubstitution::Formatters::Base
  def self.description
    "Takes a single n argument. Returns the right most n characters from the input."
  end

  def self.has_parameters?
    true
  end

  def initialize(character_count)
    @character_count = character_count
  end

  def format(value)
    if (as_string = value.to_s).size > @character_count
      as_string[-@character_count, @character_count]
    else
      as_string
    end
  end
end
