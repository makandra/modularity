# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'modularity/version'

Gem::Specification.new do |s|
  s.name = %q{modularity}
  s.version = Modularity::VERSION
  s.authors = ["Henning Koch"]
  s.email = %q{github@makandra.de}
  s.homepage = %q{http://github.com/makandra/modularity}
  s.summary = %q{Traits and partial classes for Ruby}
  s.description = %q{Traits and partial classes for Ruby}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '<2')
  s.add_development_dependency('rspec_candy')

end
