# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack_http_preload/version'

Gem::Specification.new do |spec|
  spec.name          = "rack_http_preload"
  spec.version       = RackHttpPreload::VERSION
  spec.authors       = ["Nate Berkopec"]
  spec.email         = ["nate.berkopec@gmail.com"]

  spec.summary       = %q{Add rel=preload headers to Rack applications}
  spec.description   = %q{Add rel=preload headers to Rack applications}
  spec.homepage      = "https://github.com/nateberkopec/rack_http_preload"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "sinatra", "~> 1.4"
  spec.add_development_dependency "rack", "~> 1.6"
  spec.add_development_dependency "mime-types", "~> 3.0"
end
