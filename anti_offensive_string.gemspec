# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'anti_offensive_string/version'

Gem::Specification.new do |spec|
  spec.name          = "anti_offensive_string"
  spec.version       = AntiOffensiveString::VERSION
  spec.authors       = ["Shota Fukumori (sora_h)"]
  spec.email         = ["her@sorah.jp"]
  spec.description   = %q{Respond error for requests include some offensive string, that may crash browsers}
  spec.summary       = %q{Respond error for requests include some offensive string, that may crash browsers http://techcrunch.com/2013/08/29/bug-in-apples-coretext-allows-specific-string-of-characters-to-crash-ios-6-os-x-10-8-apps/}
  spec.homepage      = "https://github.com/sorah/anti_offensive_string"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", '~> 5.0.6'
  spec.add_development_dependency "rack-test"
end
