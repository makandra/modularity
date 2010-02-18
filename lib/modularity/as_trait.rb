module Modularity
  module AsTrait
    def as_trait(&block)
      @trait_macro = block
    end
  end
end

Object.send :include, Modularity::AsTrait
