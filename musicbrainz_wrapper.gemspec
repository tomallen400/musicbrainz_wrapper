# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'musicbrainz_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "musicbrainz_wrapper"
  spec.version       = MusicbrainzWrapper::VERSION
  spec.authors       = ["tomallen400"]
  spec.email         = ["tomallen4000@gmail.com"]
  spec.description   = "A object orientated gem for the Musizbrainz API"
  spec.summary       = "A object orientated gem for the Musizbrainz API"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
