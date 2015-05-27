Gem::Specification.new do |spec|
  spec.name          = "lita-destiny"
  spec.version       = "0.1.1"
  spec.authors       = ["PDaily"]
  spec.email         = ["pat.irwin4@gmail.com"]
  spec.description   = "Small lita.io handler for interacting with the Destiny API"
  spec.summary       = "Lightweight handler to help consume information related to Destiny the game and relaying it neatly in a chatroom."
  spec.homepage      = "http://github.com/pDaily/lita-destiny"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", "~> 4.3"
  spec.add_runtime_dependency "httparty", "~> 0.13", ">= 0.13.5"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug", "~> 3.1", ">= 3.1.0"
  spec.add_development_dependency "rake", "~> 10.4", ">= 10.4.2"
  spec.add_development_dependency "rack-test", "~> 0.6", ">= 0.6.3"
  spec.add_development_dependency "rspec", "~> 3.0", ">= 3.0.0"
  spec.add_development_dependency "simplecov", "~> 0.10", ">= 0.10.0"
  spec.add_development_dependency "coveralls", "~> 0.8", ">= 0.8.1"
end