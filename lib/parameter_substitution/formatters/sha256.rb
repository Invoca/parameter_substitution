# frozen_string_literal: true

class ParameterSubstitution::Formatters::Sha256 < ParameterSubstitution::Formatters::Base
  def self.description
    "Generates a sha256 hash of the value."
  end

  def self.format(value)
    Digest::SHA256.hexdigest(value.to_s)
  end
end
