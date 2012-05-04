# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lector/version"

Gem::Specification.new do |s|
  s.name        = "lector"
  s.version     = Lector::VERSION
  s.authors     = ["Alan Dipert", "Michael Fogus", "Alex Redington"]
  s.email       = ["alan@dipert.org"]
  s.homepage    = "http://github.com/alandipert/lector"
  s.summary     = %q{A Ruby data reader.}
  s.description = %q{lector parses Ruby data into Ruby data structures.}

  s.rubyforge_project = "lector"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'simplecov'
  s.add_runtime_dependency 'citrus'
end
