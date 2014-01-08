module Modularity

  class ParametrizedTrait < Module

    def initialize(blank_trait, args)
      @args = args
      @macro = blank_trait.instance_variable_get(:@modularity_macro)
      include(blank_trait)
    end

    def included(base)
      base.class_exec(*@args, &@macro)
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

      def self.[](*args)
        blank_trait = self
        ParametrizedTrait.new(blank_trait, args)
      end

    end

  end
end

Module.send(:include, Modularity::AsTrait)
