require 'modularity/as_trait'
require 'modularity/inflector'

module Modularity
  module Does

    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def does(trait_name, *args)
        trait_name = Modularity::Inflector.camelize(trait_name.to_s)
        trait = Modularity::Inflector.constantize(trait_name)
        include(trait)
        macro = trait.instance_variable_get("@as_trait") or raise "Missing as_trait directive in #{trait_name}"
        class_exec(*args, &macro)
      end
    end

  end
end

Object.send :include, Modularity::Does
