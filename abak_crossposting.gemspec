# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'abak_crossposting/version'

Gem::Specification.new do |gem|
  gem.name          = "abak_crossposting"
  gem.version       = AbakCrossposting::VERSION
  gem.authors       = ["Natalia Remizova"]
  gem.email         = ["reminate@gmail.com"]
  gem.description   = %q{Crossposting to social networks (facebook, vkontakte)}
  gem.summary       = %q{Crossposting to social networks (facebook, vkontakte)}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "koala", "~> 1.6.0"
  gem.add_runtime_dependency "vkontakte_api", "~> 1.1"
  gem.add_runtime_dependency "mime-types"
  gem.add_development_dependency "rspec"
end
