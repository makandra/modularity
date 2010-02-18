require 'modularity/inflector'
require 'modularity/as_trait'

module Modularity
  module Does

    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def does(trait_name, *args)
        trait_name = "#{Modularity::Inflector.camelize(trait_name.to_s)}Trait"
        trait = Modularity::Inflector.constantize(trait_name)
        macro = trait.instance_variable_get("@trait_macro") or raise "Missing trait directive in #{trait_name}"
        class_exec(*args, &macro)
      end
    end

  end
end

Object.send :include, Modularity::Does
