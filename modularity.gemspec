lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'modularity/version'

Gem::Specification.new do |spec|
  spec.name = 'modularity'
  spec.version = Modularity::VERSION
  spec.required_ruby_version = '>= 2.5.0'
  spec.authors = ['Henning Koch']
  spec.email = ['henning.koch@makandra.de']

  spec.summary = 'Traits and partial classes for Ruby'
  spec.description = 'Traits and partial classes for Ruby'
  spec.homepage = 'https://github.com/makandra/modularity'
  spec.license = 'MIT'
  spec.metadata = { 'rubygems_mfa_required' => 'true' }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r(^exe/)) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Development dependencies are defined in the Gemfile (therefore no `spec.add_development_dependency` directives)
end
