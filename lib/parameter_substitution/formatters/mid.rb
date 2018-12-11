# frozen_string_literal: true

class ParameterSubstitution::Formatters::Mid < ParameterSubstitution::Formatters::Base
  def self.description
    "Takes starting_position and character_count as arguments. Returns the character_count characters starting from starting_position from the input."
  end

  def self.has_parameters?
    true
  end

  def initialize(starting_position, character_count)
    @starting_position = starting_position
    @character_count = character_count
  end

  def format(value)
    value.to_s[@starting_position, @character_count]
  end
end
