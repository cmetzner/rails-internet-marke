# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "rails-internet-marke"
  spec.version       = InternetMarke::VERSION
  spec.authors       = ["cmetzner"]
  spec.email         = ["cmetzner@christmetz-it.de"]
  spec.summary       = %q{Ruby Client for Deutsche Post InternetMarke Api}
  spec.description   = %q{Gem for use Deutsche Post InternetMarke Api in Ruby. Put money on your wallet and buy products of Deutsche Post InternetMarke}
  spec.homepage      = "https://github.com/cmetzner/rails-internet-marke"
  spec.license       = "MIT"

  spec.files         = ["lib/internet_marke.rb"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rspec", "~> 3.3.0"
end