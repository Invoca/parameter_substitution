# frozen_string_literal: true

require 'rspec'
require 'pry-byebug'
require 'simplecov'
require 'parameter_substitution'
require 'helpers/test_formatter_base'
require 'helpers/downcase'
require 'helpers/add_prefix'
require 'helpers/compare_string'
require 'helpers/if_nil'
require 'helpers/json_parse'

SimpleCov.start

class TestClass < ParameterSubstitution::Formatters::Base
end

ParameterSubstitution.configure do |config|
  config.custom_formatters = { "test" => "TestClass" }
end
