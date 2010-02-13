require 'rake'
# require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: Run all specs.'
task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new() do |t|
  t.spec_opts = ['--options', "\"spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the modularity gem'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'modularity'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "modularity"
    gemspec.summary = "Traits and partial classes for Ruby"
    gemspec.email = "github@makandra.de"
    gemspec.homepage = "http://github.com/makandra/modularity"
    gemspec.description = "Traits and partial classes for Ruby"
    gemspec.authors = ["Henning Koch"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

