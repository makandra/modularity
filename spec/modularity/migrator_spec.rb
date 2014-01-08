require 'spec_helper'

require 'modularity/migrator' # this is an optional file and thus not loaded automatically

describe Modularity::Migrator do

  subject do
    Modularity::Migrator
  end

  describe '.fix_filename' do

    it 'should replace the suffix _trait with a prefix does' do
      subject.send(:fix_filename, '/path/to/search_trait.rb').should == '/path/to/does_search.rb'
    end

    it "should not rename files that don't end in _trait.rb" do
      subject.send(:fix_filename, '/path/to/search.rb').should == '/path/to/search.rb'
    end

  end

  describe '.fix_code' do

    it 'renames a module FooBarTrait to DoesFooBar' do

      old_code = <<-RUBY
        module Namespace::FooBarTrait
          as_trait do
            define_method :foo do
            end
            define_method :bar do
            end
          end
        end
      RUBY

      new_code = <<-RUBY
        module Namespace::DoesFooBar
          as_trait do
            define_method :foo do
            end
            define_method :bar do
            end
          end
        end
      RUBY

      subject.send(:fix_code, old_code).should == new_code
    end

    it "does not rename modules that aren't traits" do

      old_code = <<-RUBY
        module Namespace::FooBar
          def foo
          end
          def bar
          end
        end
      RUBY

      subject.send(:fix_code, old_code).should == old_code
    end

    it 'replaces does calls with include' do

      old_code = <<-RUBY
        class User < ActiveRecord::Base
          does 'user/search'
          does 'user/account_settings'
          does 'trashable'
        end
      RUBY

      new_code = <<-RUBY
        class User < ActiveRecord::Base
          include User::DoesSearch
          include User::DoesAccountSettings
          include DoesTrashable
        end
      RUBY

      subject.send(:fix_code, old_code).should == new_code
    end

    it 'puts does parameters into square brackets' do

      old_code = <<-RUBY
        class User < ActiveRecord::Base
          does 'flag', :active, :default => true
          does 'record/search', :field => :email
        end
      RUBY

      new_code = <<-RUBY
        class User < ActiveRecord::Base
          include DoesFlag[:active, :default => true]
          include Record::DoesSearch[:field => :email]
        end
      RUBY

      subject.send(:fix_code, old_code).should == new_code

    end

  end

end
