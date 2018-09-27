# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "parameter_substitution"
  spec.version       = "0.1.0"
  spec.authors       = ["Collin McGrath"]
  spec.email         = ["cmcgrath@invoca.com"]

  spec.summary       = 'Handles parsing an input strings with embedded substitution parameters and replacing them with values from a provided mapping.'
  spec.description   = 'The substitution can be formatted using a syntax that looks like method calls'
  spec.homepage      = 'https://github.com/Invoca/parameter_substitution'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'activesupport', '~> 4.0'
  spec.add_development_dependency 'builder'
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency 'hobo_support'
  spec.add_development_dependency 'parslet', '~> 1.8'
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

end
