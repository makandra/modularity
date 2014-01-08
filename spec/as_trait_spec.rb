require 'spec_helper'

describe Modularity::AsTrait do

  describe '.included' do
    
    before :each do
      @doing_class = Class.new
    end

    describe 'without parameters' do
  
      it "applies the trait macro of the given module" do

        module DoesSome
          as_trait do
            some_trait_included
          end
        end

        @doing_class.should_receive(:some_trait_included)

        @doing_class.class_eval do
          include DoesSome
        end

      end

      it "applies the trait macro of the given namespaced module" do

        module Some
          module DoesChild
            as_trait do
              some_child_trait_included
            end
          end
        end

        @doing_class.should_receive(:some_child_trait_included)

        @doing_class.class_eval do
          include Some::DoesChild
        end

      end

      it "lets a trait define methods with different visibility" do

        module DoesVisibility
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

        @doing_class.class_eval do
          include DoesVisibility
        end

        instance = @doing_class.new

        instance.public_methods.collect(&:to_s).should include("public_method_from_trait")
        instance.protected_methods.collect(&:to_s).should include("protected_method_from_trait")
        instance.private_methods.collect(&:to_s).should include("private_method_from_trait")

      end

    end

    describe "with parameters" do

      it "it applies a trait macro with parameters" do

        module DoesCallMethod
          as_trait do |field|
            send(field)
          end
        end

        @doing_class.should_receive(:foo)
        @doing_class.class_eval do
          include DoesCallMethod[:foo]
        end

      end

      it "facilitates metaprogramming acrobatics" do

        module DoesDefineConstantMethod
          as_trait do |name, return_value|
            define_method name do
              return_value
            end
          end
        end

        @doing_class.class_eval do
          include DoesDefineConstantMethod["some_method", "some_return_value"]
        end

        instance = @doing_class.new
        instance.should respond_to(:some_method)
        instance.some_method.should == "some_return_value"
      end

    end

  end

end
