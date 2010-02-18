require File.dirname(__FILE__) + '/spec_helper'

module Trait
  as_trait do
    "hi world"
  end
end

module ParametrizedTrait
  as_trait do |name|
    "hi, #{name}"
  end
end

describe Modularity::AsTrait do

  describe 'as_trait' do

    it "should let modules save a proc upon loading" do
      Trait.instance_variable_get("@trait_macro").call.should == "hi world"
    end

    it "should let modules save a proc with parameters upon loading" do
      ParametrizedTrait.instance_variable_get("@trait_macro").call("jean").should == "hi, jean"
    end

  end
  
end
