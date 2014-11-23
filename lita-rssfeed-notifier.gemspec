Gem::Specification.new do |spec|
  spec.name          = "lita-rssfeed-notifier"
  spec.version       = "0.0.1"
  spec.authors       = ["takuto.komazaki"]
  spec.email         = ["komazarari@gmail.com"]
  spec.description   = %q{Lita Handler to watch and notify a RSS feed}
  spec.summary       = %q{Lita Handler to watch and notify a RSS feed}
  spec.homepage      = "https://github.com/komazarari/lita-rssfeed-notifier"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
