# frozen_string_literal: true

class ParameterSubstitution::Formatters::Md5 < ParameterSubstitution::Formatters::Base
  def self.description
    "Generates an md5 hash of the value."
  end

  def self.format(value)
    Digest::MD5.hexdigest(value.to_s)
  end
end
