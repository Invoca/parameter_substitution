# frozen_string_literal: true

class ParameterSubstitution::Formatters::Lookup < ParameterSubstitution::Formatters::Base
  def self.description
    "This takes a table as a constructor parameter and performs a lookup from the value. If the value exists as a key in the lookup table, the key's value is returned."
  end

  def self.has_parameters?
    true
  end

  def initialize(lookup_table)
    @lookup_table = lookup_table
  end

  def format(value)
    @lookup_table[value.to_s]
  end
end
