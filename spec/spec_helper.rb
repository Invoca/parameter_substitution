require 'rspec'
require 'pry-byebug'
require 'simplecov'
require 'parameter_substitution'
require_relative '../spec/helpers/test_formatter_base'

SimpleCov.start

ParameterSubstitution.configure do |config|
  config.method_call_base_class = TestFormatterBase
end
