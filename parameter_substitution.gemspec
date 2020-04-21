# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name         = "parameter_substitution"
  spec.version      = "0.2.3"
  spec.authors      = ["Bob Smith", "James Ebentier"]
  spec.email        = ["bob@invoca.com", "jebentier@invoca.com", "cmcgrath@invoca.com"]

  spec.summary     = 'Handles parsing an input strings with embedded substitution parameters and replacing them with values from a provided mapping.'
  spec.description = 'The substitution can be formatted using a syntax that looks like method calls'
  spec.homepage    = 'https://github.com/Invoca/parameter_substitution'
  spec.files       = ['lib/parameter_substitution.rb']

  spec.metadata = {
    'allowed_push_host' => 'https://gem.fury.io/invoca'
  }

  spec.add_development_dependency 'activesupport', '~> 4.0'
  spec.add_development_dependency 'builder'
  spec.add_development_dependency 'bump',          '~> 0.6.1'
  spec.add_development_dependency 'bundler',       '~> 1.12'
  spec.add_development_dependency 'hobo_support'
  spec.add_development_dependency 'invoca-utils',  '~> 0.0.3'
  spec.add_development_dependency 'parslet',       '~> 1.8'
  spec.add_development_dependency 'rake',          '~> 10.0'
  spec.add_development_dependency 'rspec',         '~> 3.0'
end
