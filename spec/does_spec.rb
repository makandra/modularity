require 'spec_helper'

module SomeTrait
  as_trait do
    some_trait_included
  end
end

module Some
  module ChildTrait
    as_trait do
      some_child_trait_included
    end
  end
end

module CallMethodTrait
  as_trait do |field|
    send(field)
  end
end

module VisibilityTrait
  as_trait do
    def public_method_from_trait
    end
    protected
    def protected_method_from_trait
    end
    private
    def private_method_from_trait
    end
  end
end

module DefineConstantMethodTrait
  as_trait do |name, return_value|
    define_method name do
      return_value
    end
  end
end

class Doer
end

describe Modularity::AsTrait do

  describe 'does' do
  
    it "should apply the named module" do
      Doer.should_receive(:some_trait_included)
      Doer.class_eval do
        does "some"
      end
    end
    
    it "should apply a namespaced module, using slash-notation like require" do
      Doer.should_receive(:some_child_trait_included)
      Doer.class_eval do
        does "some/child"
      end
    end
    
    it "should class_eval the as_trait proc on the doer" do
      Doer.should_receive(:foo)
      Doer.class_eval do
        does "call_method", :foo
      end
    end
    
    it "should allow the trait to define methods with different visibility" do
      Doer.class_eval do
        does "visibility"
      end
      instance = Doer.new
      instance.public_methods.collect(&:to_s).should include("public_method_from_trait")
      instance.protected_methods.collect(&:to_s).should include("protected_method_from_trait")
      instance.private_methods.collect(&:to_s).should include("private_method_from_trait")
    end
    
    it "should allow the trait to perform metaprogramming acrobatics" do
      Doer.class_eval do
        does "define_constant_method", "some_method", "some_return_value"
      end
      instance = Doer.new
      instance.should respond_to(:some_method)
      instance.some_method.should == "some_return_value"
    end

  end

end
