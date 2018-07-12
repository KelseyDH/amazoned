
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "amazoned/version"

Gem::Specification.new do |spec|
  spec.name          = "amazoned"
  spec.version       = Amazoned::VERSION
  spec.authors       = ["kelseydh"]
  spec.email         = ["kelseyh@gmail.com"]

  spec.summary       = %q{A manual scraper for Amazon ASIN product data}
  spec.description   = %q{This gem allows you to scrap product information from Amazon without the need to register for Amazon's API}
  spec.homepage      = "http://twitter.com/kelsoh"
  spec.license       = "MIT"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-console"
  spec.add_dependency "mechanize", '~> 2.7', '>= 2.7.6'
  spec.add_dependency "activesupport"
end
