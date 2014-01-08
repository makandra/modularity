Modularity 2 - Traits and partial classes for Ruby
==================================================

Modularity enhances Ruby's [`Module`] so it can be used traits and partial classes.
This allows very simple definition of meta-programming macros like the
`has_many` that you know from Rails.

Modularity also lets you organize large models into multiple source files
in a way that is less awkward than using modules.

Note that this is **Modularity 2**, which has a different syntax older version.
Modularity 1 users can use [a script to migrate their code](#migrating-from-modularity-1)
or use the [modularity1 branch](https://github.com/makandra/modularity/tree/modularity1).


Example 1: Easy meta-programming macros
----------------------------------------

Ruby allows you to construct classes using meta-programming macros like
`acts_as_tree` or `has_many :items`. These macros will add methods,
callbacks, etc. to the calling class. However, right now Ruby (and Rails) makes it awkward to define
such macros in your project as part of your application domain.

Modularity allows you to extract common behaviour into reusable macros by defining traits with parameters.
Your macros can live in your application, allowing you to express your application domain in both classes
and macros.

Here is an example of a `strip_field` macro, which created setter methods that remove leading and trailing whitespace from newly assigned values:

    # app/models/article.rb
    class Article
      include DoesStripFields[:name, :brand]
    end

    # app/models/shared/does_strip_fields.rb
    module DoesStripFields
      as_trait do |*fields|
        fields.each do |field|
          define_method("#{field}=") do |value|
            self[field] = value.strip
          end
        end
      end
    end
  
We like to add `app/models/shared` and `app/controllers/shared` to the load paths of our Rails projects.
These are great places to store macros that are re-used from multiple classes.


Example 2: Mixins with class methods
------------------------------------

Using a module to add both instance methods and class methods is
[very awkward](http://redcorundum.blogspot.com/2006/06/mixing-in-class-methods.html).
Modularity does away with the clutter and lets you say this:

    # app/models/model.rb
    class Model
      include Mixin
    end

    # app/models/mixin.rb
    module Mixin
      as_trait do
        def instance_method
          # ...
        end
        def self.class_method
          # ..
        end
      end
    end

`private` and `protected` will also work as expected when defining a trait.


Example 3: Splitting a model into multiple source files
-------------------------------------------------------

Models are often concerned with multiple themes like "authentication", "contact info" or "permissions", each requiring
a couple of validations and callbacks here, and some method there. Modularity lets you organize your model into multiple
partial classes, so each file can deal with a single aspect of your model:

    # app/models/user.rb
    class User < ActiveRecord::Base
      include User::DoesAuthentication
      include User::DoesAddress
    end

    # app/models/user/does_authentication.rb
    module User::DoesAuthentication
      as_trait do
        # methods, validations, etc. regarding usernames and passwords go here
      end
    end

    # app/models/user/does_permissions.rb
    module User::DoesPermissions
      as_trait do
        # methods, validations, etc. regarding contact information go here
      end
    end

Some criticism has been raised for splitting large models into files like this.
Essentially, even though have an easier time navigating your code, you will still
have one giant model with many side effects.

There are [many better ways](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/)
to decompose a huge Ruby class.


Installation
------------

Add the following to your `Gemfile`:

    gem 'modularity', '>=2'

Now run `bundle install`.


Migrating from Modularity 1
---------------------------

If you have been using Modularity 1 with the `does` syntax, we provide a script to migrate your Ruby project
automatically.

1. Make sure your project has tests and you have a backup of your files (or pushed your commits to Git)

2. From your project directory, do this:

        find . -name "*.rb" | migrate-modularity1-to-modularity2

3. The script will rename your files and change your code. It will also syntax-check your files after conversion
   (since the script is not perfect).

4. Check the diff to see what the script has done.

5. Run tests to see if everything still works.




Credits
-------

Henning Koch from [makandra.com](http://makandra.com/)

