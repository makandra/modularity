module Modularity

  class ParametrizedTrait < Module

    def initialize(blank_trait, args, kwargs)
      @args = args
      @kwargs = kwargs
      @macro = blank_trait.instance_variable_get(:@modularity_macro)
      include(blank_trait)
    end

    def included(base)
      if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.7')
        base.class_exec(*@args, &@macro)
      else
        base.class_exec(*@args, **@kwargs, &@macro)
      end
    end

  end

  module AsTrait

    def as_trait(&macro)

      @modularity_macro = macro

      def self.included(base)
        unless base.is_a?(ParametrizedTrait)
          base.class_exec(&@modularity_macro)
        end

      end

      if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.7')
        def self.[](*args)
          blank_trait = self
          ParametrizedTrait.new(blank_trait, args, {})
        end
      else
        def self.[](*args, **kwargs)
          blank_trait = self
          ParametrizedTrait.new(blank_trait, args, kwargs)
        end
      end

    end

  end
end

Module.send(:include, Modularity::AsTrait)
