# frozen_string_literal: true

require 'rspec'
require 'pry-byebug'
require 'simplecov'
require 'parameter_substitution'
require 'helpers/test_formatter_base'

SimpleCov.start

class TestClass < ParameterSubstitution::Formatters::Base
end

ParameterSubstitution.configure do |config|
  config.custom_formatters = { "test" => TestClass }
end
