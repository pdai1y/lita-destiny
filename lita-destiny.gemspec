Gem::Specification.new do |spec|
  spec.name          = "lita-destiny"
  spec.version       = "0.1.0"
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

  spec.add_runtime_dependency "lita", ">= 4.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
