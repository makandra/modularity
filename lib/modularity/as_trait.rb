module Modularity
  module AsTrait

    def as_trait(&block)
      @as_trait = block
    end

  end
end

Module.send :include, Modularity::AsTrait
